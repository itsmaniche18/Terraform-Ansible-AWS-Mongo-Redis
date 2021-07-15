variable "AWS_ACCESS_KEY" {

}
variable "AWS_SECRET_KEY" {

}
variable "AWS_REGION" {
}

variable "IMAGE_ID" {
  type        = string
  description = "Name of image id."
}

variable "KEY_NAME" {
  type        = string
  description = "Key Name for Instance"
}

variable "INSTANCE_TYPE" {
  type        = string
  description = "Instance Type"
}

variable "INSTANCE_TYPE_REDIS" {
  type        = string
  description = "Instance Type for Redis"
}

variable "PRIVATE_KEY" {
  type        = string
  description = "Private Key for login"
}

variable "USER" {
  type        = string
  description = "Username for login"
}

variable "SOURCE" {
  type        = string
  description = "Source"
}

variable "DESTINATION" {
  type        = string
  description = "Destination"
}
