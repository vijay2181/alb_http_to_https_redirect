resource "aws_iam_role" "ecr_access_role" {
  name               = "Instance-Role"
  assume_role_policy = file("./policy/assumerolepolicy.json")
}

resource "aws_iam_policy" "policy-1" {
  name        = "ECR-Policy"
  description = "Policy for pulling ECR images"
  policy      = file("./policy/ecrpolicy.json")
}

resource "aws_iam_policy_attachment" "policy-attach1" {
  name       = "policy-attachment1"
  roles      = ["${aws_iam_role.ecr_access_role.name}"]
  policy_arn = aws_iam_policy.policy-1.arn
}


resource "aws_iam_instance_profile" "vijay_profile" {
  name = "vijay_profile"
  role = aws_iam_role.ecr_access_role.name
}
