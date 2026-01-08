# Exporting resources to import outside of network module.
output "subnet_id" {
  value = aws_subnet.aws_subnet.id
}

output "aws_security_group_allow_ssh" {
  value = aws_security_group.allow_ssh.id
}

output "aws_security_group_squid_port" {
  value = aws_security_group.squid_port.id
}

output "vpc_security_group_ids" {
  value = [
    aws_security_group.allow_ssh.id,
    aws_security_group.squid_port.id
  ]
}
