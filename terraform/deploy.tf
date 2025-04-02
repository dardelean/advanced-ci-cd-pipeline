# Development
resource "aws_codedeploy_app" "myapp_dev" {
  compute_platform = "Server" # corresponds to "EC2/On-Premises" in the console
  name             = "dardelean_myapp_dev"
}

resource "aws_codedeploy_deployment_group" "deployment_group_dev" {
  app_name     = aws_codedeploy_app.myapp_dev.name
  deployment_group_name = "deployment_group_dev"
  service_role_arn = aws_iam_role.service-role-codedeploy.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
        ec2_tag_filter {
        key   = "Name"
        type  = "KEY_AND_VALUE"
        value = "Development EC2"
        }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}

# Production
resource "aws_codedeploy_app" "myapp_prod" {
  compute_platform = "Server" # corresponds to "EC2/On-Premises" in the console
  name             = "dardelean_myapp_prod"
}

resource "aws_codedeploy_deployment_group" "deployment_group_prod" {
  app_name     = aws_codedeploy_app.myapp_prod.name
  deployment_group_name = "deployment_group_prod"
  service_role_arn = aws_iam_role.service-role-codedeploy.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  ec2_tag_set {
        ec2_tag_filter {
        key   = "Name"
        type  = "KEY_AND_VALUE"
        value = "Production EC2"
        }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}