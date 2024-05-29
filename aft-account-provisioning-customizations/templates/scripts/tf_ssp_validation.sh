#!/bin/bash
#------------------------------------------------------------
# Script Name: tf_ssp_validation.sh
# Description: Script to validate Terraform code
# Credits : https://github.com/aws-samples/aws-codepipeline-terraform-cicd-samples/blob/main/templates/scripts/tf_ssp_validation.sh
#------------------------------------------------------------

# Accept Command Line Arguments
SKIPVALIDATIONFAILURE=$1
tfValidate=$2
tfFormat=$3
tfCheckov=$4
tfTfsec=$5
# -----------------------------

echo "### VALIDATION Overview ###"
echo "-------------------------"
echo ""
echo ""
echo "Skip Validation Errors on Failure : ${SKIPVALIDATIONFAILURE}"
echo ""
echo "Terraform Validate : ${tfValidate}"
echo ""
echo "Terraform Format   : ${tfFormat}"
echo ""
echo "Terraform checkov  : ${tfCheckov}"
echo ""
echo "Terraform tfsec    : ${tfTfsec}"
echo ""
echo ""
echo "------------------------"
terraform init
if (( ${tfValidate} == "Y"))
then
    echo "## VALIDATION : Validating Terraform code ..."
    terraform validate
fi
tfValidateOutput=$?

if (( ${tfFormat} == "Y"))
then
    echo "## VALIDATION : Formatting Terraform code ..."
    terraform fmt -recursive
fi
tfFormatOutput=$?

if (( ${tfCheckov} == "Y"))
then
    echo "## VALIDATION : Running checkov ..."
    #checkov -s -d .
    checkov -o junitxml --framework terraform -d ./ >checkov.xml
fi
tfCheckovOutput=$?

if (( ${tfTfsec} == "Y"))
then
    echo "## VALIDATION : Running tfsec ..."
    #tfsec .
    tfsec ./ --format junit --out tfsec-junit.xml
fi
tfTfsecOutput=$?

echo "## VALIDATION Summary ##"
echo "------------------------"
echo "Terraform Validate : ${tfValidateOutput}"
echo "Terraform Format   : ${tfFormatOutput}"
echo "Terraform checkov  : ${tfCheckovOutput}"
echo "Terraform tfsec    : ${tfTfsecOutput}"
echo "------------------------"

if (( ${SKIPVALIDATIONFAILURE} == "Y" ))
then
  #if SKIPVALIDATIONFAILURE is set as Y, then validation failures are skipped during execution
  echo "## VALIDATION : Skipping validation failure checks..."
elif (( $tfValidateOutput == 0 && $tfFormatOutput == 0 && $tfCheckovOutput == 0  && $tfTfsecOutput == 0 ))
then
  echo "## VALIDATION : Checks Passed!!!"
else
  # When validation checks fails, build process is halted.
  echo "## ERROR : Validation Failed"
  exit 1;
fi