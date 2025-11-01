# Generate RSA 4096 keypair locally
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Import public key into AWS as a Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

# Save private key locally (filename includes .pem)
resource "local_file" "private_key" {
  content         = tls_private_key.rsa_4096.private_key_pem
  filename        = "${var.key_name}.pem"
  file_permission = "0400"   # read-only for owner (Linux-like permission)
}

# Example security group allowing RDP (3389) — adjust for production
resource "aws_security_group" "win_sg" {
  name        = "${var.key_name}-sg"
  description = "Allow RDP for Windows instance"
  vpc_id      = try(data.aws_subnet.selected.vpc_id, null)

  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # restrict this in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# If you provide subnet_id, use it; otherwise launch in default subnet
data "aws_subnet" "selected" {
  id = var.subnet_id
  # If you don't pass subnet_id, this will error - so you can remove data source & subnet usage.
  # It's optional; adjust for your networking.
}

# Launch Windows EC2 instance
resource "aws_instance" "windows" {
  ami                         = var.windows_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.win_sg.id]
  subnet_id                   = var.subnet_id != "" ? var.subnet_id : null
  associate_public_ip_address = true

  tags = {
    Name = "tf-windows-${var.key_name}"
  }

  # Optional: wait for status checks (slows creation until instance is ready)
  # connection block not used for windows password retrieval
}
