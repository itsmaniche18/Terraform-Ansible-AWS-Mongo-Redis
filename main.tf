module "app" {
  source              = "./instances"
  IMAGE_ID            = var.IMAGE_ID
  INSTANCE_TYPE       = var.INSTANCE_TYPE
  INSTANCE_TYPE_REDIS = var.INSTANCE_TYPE_REDIS
  PRIVATE_KEY         = var.PRIVATE_KEY
  USER                = var.USER
  KEY_NAME            = var.KEY_NAME
  SOURCE              = var.SOURCE
  DESTINATION         = var.DESTINATION
}
