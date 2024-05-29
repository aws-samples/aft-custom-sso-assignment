import json
import logging
import time
import os
import itertools
from time import sleep
import boto3
from boto3.dynamodb.conditions import Key

SSM_AFT_REQUEST_METADATA_PATH = "/aft/resources/ddb/aft-request-metadata-table-name"
AFT_REQUEST_METADATA_EMAIL_INDEX = "emailIndex"
session = boto3.Session()
logger = logging.getLogger()
if 'log_level' in os.environ:
    logger.setLevel(os.environ['log_level'])
    logger.info("Log level set to %s" % logger.getEffectiveLevel())
else:
    logger.setLevel(logging.INFO)


def lambda_handler(event, context):
  try:
      
      account_info = event["payload"]["account_info"]["account"]["id"]
      account_sso_request = json.loads(event["payload"]["account_request"]["custom_fields"])

      InstanceArn = account_sso_request['InstanceArn']
      PermissionSetArn_AdminAccess = account_sso_request['AdminAccessPermissionSetArn']
      PrincipalId_AdminAccess = account_sso_request['AdminAccessPrincipalId']
      PermissionSetArn_ReadOnlyAccess = account_sso_request['ReadOnlyAccessPermissionSetArn']
      PrincipalId_ReadOnlyAccess = account_sso_request['ReadOnlyAccessPrincipalId']

      cross_account_role_name = os.getenv("CROSS_ACC_ROLE_NAME")
      ct_account_info = os.getenv("AFT_CT_ACCOUNT")
      role_arn = f"arn:aws:iam::{ct_account_info}:role/{cross_account_role_name}"
      stsMaster = boto3.client("sts")

      logger.info("Assume CT Session")


      assumeRoleResult  = stsMaster.assume_role (
          RoleArn=role_arn,
          RoleSessionName="AWSAFT-Session"
      )

      sessionAccount = boto3.Session (
          aws_access_key_id=assumeRoleResult["Credentials"]["AccessKeyId"],
          aws_secret_access_key=assumeRoleResult["Credentials"]["SecretAccessKey"],
          aws_session_token=assumeRoleResult["Credentials"]["SessionToken"],
          region_name=os.getenv("REGION"),
      )
          
       

      logger.info("Assign SSO Groups and Permission Sets for Target Accounts")


      sso = sessionAccount.client(service_name='sso-admin', region_name=os.getenv("REGION"))

      sso_permission_set_list = [PermissionSetArn_AdminAccess, PermissionSetArn_ReadOnlyAccess]
      sso_group_list = [PrincipalId_AdminAccess, PrincipalId_ReadOnlyAccess]
      

      for ps, grp in zip(sso_permission_set_list, sso_group_list):
        
        sso_change_response = sso.create_account_assignment(
            InstanceArn=str(InstanceArn),
            TargetId=str(account_info),
            TargetType='AWS_ACCOUNT',
            PermissionSetArn=str(ps),
            PrincipalType='GROUP',
            PrincipalId=str(grp)
        )

      status = sso_change_response["AccountAssignmentCreationStatus"]["Status"]
      request_id = sso_change_response["AccountAssignmentCreationStatus"]["RequestId"]
      print("Status is {}".format(status))
      while status == "IN_PROGRESS":
            print("Sleeping for 0.5 seconds...")
            time.sleep(0.5)
            response = sso.describe_account_assignment_creation_status(
                InstanceArn=str(InstanceArn),
                AccountAssignmentCreationRequestId=request_id
            )
            status = response["AccountAssignmentCreationStatus"]["Status"]
            print("Status is {}".format(status))


      return json.loads(json.dumps(sso_change_response, default=str))
  


  except Exception as e:
      logger.exception("Error on AFT Acount Alternate contact - {}".format(e))
      raise