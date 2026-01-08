output "aws_instance_name" {
  value = aws_instance.aws_instance.tags["Name"]
}
