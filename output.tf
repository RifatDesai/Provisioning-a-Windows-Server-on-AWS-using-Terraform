output "private_key_file" {
  value       = local_file.private_key.filename
  description = "Path to the generated private key file (keep secure)."
}

output "instance_id" {
  value       = aws_instance.windows.id
  description = "Launched Windows instance ID."
}

output "key_pair_name" {
  value = aws_key_pair.key_pair.key_name
}

output "public_ip" {
  value = aws_instance.windows.public_ip
  description = "Public IP for RDP (if instance has public IP)."
}