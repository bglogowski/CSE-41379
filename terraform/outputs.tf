output "private_key" {
  value     = tls_private_key.rsa_4096.private_key_pem
  sensitive = true
}

