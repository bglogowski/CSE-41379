output "private_key" {
  value     = tls_private_key.rsa_4096.private_key_pem
  sensitive = true
}

output "nat_gateway_ips" {
  value = aws_eip.nat_gateway[*].public_ip
}

output "jenkins_server_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "jenkins_executor_public_ips" {
  value = aws_instance.jenkins_executor[*].public_ip
}


output "jenkins_private_executor_private_ips" {
  value = aws_instance.private_executor_test[*].private_ip
}

output "sonarqube_server_public_ip" {
  value = aws_instance.sonarqube_server.public_ip
}


output "jenkins_server_private_ip" {
  value = aws_instance.jenkins_server.private_ip
}

output "jenkins_executor_private_ips" {
  value = aws_instance.jenkins_executor[*].private_ip
}

output "sonarqube_server_private_ip" {
  value = aws_instance.sonarqube_server.private_ip
}

