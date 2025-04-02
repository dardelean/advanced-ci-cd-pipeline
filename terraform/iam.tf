# For ec2
data "aws_iam_policy_document" "assume_role_ec2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  
  }
}

resource "aws_iam_role" "ec2_role_2024" {
  name = "ec2_role_2024"
  assume_role_policy = data.aws_iam_policy_document.assume_role_ec2.json
}

resource "aws_iam_role_policy_attachment" "AmazonEC2RoleforAWSCodeDeploy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
  role       = aws_iam_role.ec2_role_2024.name
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role_2024.name
}



# For codedeploy
data "aws_iam_policy_document" "assume_role_codedeploy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "service-role-codedeploy" {
  name               = "service-role-codedeploy"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codedeploy.json
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.service-role-codedeploy.name
}


# For codepipeline
data "aws_iam_policy_document" "assume_role_codepipeline" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "service-role-codepipeline" {
  name               = "service-role-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.assume_role_codepipeline.json
}

# CodePipeline policy: allowing access to S3, CodeStarConnections
# and CodeBuild
data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket_dev.arn,
      "${aws_s3_bucket.codepipeline_bucket_dev.arn}/*",
      aws_s3_bucket.codepipeline_bucket_prod.arn,
      "${aws_s3_bucket.codepipeline_bucket_prod.arn}/*"
    ]
  }
  # we will skip the build stage, these permissions are not necessary
  # for our simple static website, but this is good to have
  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
      "codebuild:StopBuild"
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowCodedepoloy"
    effect = "Allow"

    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplication",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowResources"
    effect = "Allow"

    actions = [
      "elasticbeanstalk:*",
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "opsworks:*",
      "devicefarm:*",
      "servicecatalog:*",
      "iam:PassRole"
    ]
    resources = ["*"]
  }

#   statement {
#     # Allow CodeCommit (only if we use CodeCommit instead of GitHub)
#     effect = "Allow"
#     actions = [
#       "codecommit:GetBranch",
#       "codecommit:GetCommit",
#       "codecommit:GetUploadArchiveStatus",
#       "codecommit:GetRepository",
#       "codecommit:CancelUploadArchive",
#       "codecommit:ListBranches",
#       "codecommit:ListRepositories",
#       "codecommit:UploadArchive",
#       "codecommit:GitPull",
#       "codecommit:GitPush"
#     ]

#     resources = ["${aws_codecommit_repository.my_repository.arn}"]
#   }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.service-role-codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}