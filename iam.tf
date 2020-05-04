resource "aws_iam_role" "CloudWatchLogs" {
  name               = "CloudWatchLogs"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "CloudWatchLogs" {
  name   = "CloudWatchLogs"
  role   = aws_iam_role.CloudWatchLogs.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ],
      "Resource": [
        "*"
    ]
  }
 ]
}
EOF
}

resource "aws_iam_instance_profile" "CloudWatchLogs" {
  name = "CloudWatchLogs"
  role = aws_iam_role.CloudWatchLogs.name
}
