resource "aws_codepipeline" "pipeline_dev" {
  name          = "dardelean-pipeline_dev"
  role_arn      = aws_iam_role.service-role-codepipeline.arn
  pipeline_type = "V2"

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_dev.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "dardelean/advanced-ci-cd-pipeline" # your repository
        BranchName       = "dev"                               # development branch
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.myapp_dev.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group_dev.deployment_group_name
      }
    }
  }
}

resource "aws_codepipeline" "pipeline_prod" {
  name          = "dardelean-pipeline_prod"
  role_arn      = aws_iam_role.service-role-codepipeline.arn
  pipeline_type = "V2"

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_prod.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "dardelean/advanced-ci-cd-pipeline" # your repository
        BranchName       = "main"                              # production branch
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["source_output"]

      configuration = {
        ApplicationName     = aws_codedeploy_app.myapp_prod.name
        DeploymentGroupName = aws_codedeploy_deployment_group.deployment_group_prod.deployment_group_name
      }
    }
  }
}

resource "aws_codestarconnections_connection" "example" {
  name          = "example-connection"
  provider_type = "GitHub"
}