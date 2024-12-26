data "aws_caller_identity" "current" {}

resource "aws_iam_role" "s3_access" {
  name = "ns2312-clustee-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : "${aws_iam_openid_connect_provider.oidc.arn}"
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "${aws_iam_openid_connect_provider.oidc.url}:sub" : "system:serviceaccount:backend:tempsa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_managed_s3_readonly_policy" {
  role       = aws_iam_role.s3_access.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
