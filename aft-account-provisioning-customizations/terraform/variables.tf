variable "cloudwatch_log_group_retention" {
  description = "Lambda CloudWatch log group retention period"
  type        = string
  default     = "365"
  validation {
    condition     = contains(["1", "3", "5", "7", "14", "30", "60", "90", "120", "150", "180", "365", "400", "545", "731", "1827", "3653", "0"], var.cloudwatch_log_group_retention)
    error_message = "Valid values for var: cloudwatch_log_group_retention are (1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0)."
  }
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for the module"
  default = {
    Environment = "AFT"
    Owner       = "ACME Corp"
    Project     = "ACME Project"
    CostCenter  = "ACME"
  }
}

variable "private1_subnet_id" {
  type        = string
  description = "Private Subnet 1 to deploy Lambda"
}

variable "private2_subnet_id" {
  type        = string
  description = "Private Subnet 2 to deploy Lambda"
}


variable "private_sg_id" {
  type        = string
  description = "Private Subnet Security Group"
}

variable "aft_cross_account_role_name" {
  type        = string
  description = "CT Account role name"
  default     = "AFTCrossAccountRole"
}

variable "aft_ct_account_id" {
  type        = string
  description = "Control Tower Account ID"
}

