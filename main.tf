#Configuracion del proveedor de AWS
provider "aws" {
  region = "us-east-1" #region donde se desplegaran los recursos
}
# Security Group específico para Windows
resource "aws_security_group" "sg_windows" {
  name        = "mi-windows-sg-rdp-http"
  description = "Permite trafico RDP y HTTP para instancia Windows"
  vpc_id      = "vpc-0098cc45777949af0"

  # Entrada RDP 
  ingress {
    description = "Acceso por Escritorio Remoto RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada HTTP 
  ingress {
    description = "Trafico web HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Salida irrestricta 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-Windows"
  }
}

# Instancia EC2 Windows
resource "aws_instance" "mi_instancia_windows" {
  ami                         = "ami-0b5f645abc199e666"
  instance_type               = "t3.medium" 
  key_name                    = "mi-segundas-llaves-lr"
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.sg_windows.id]

  # Windows requiere por defecto al menos 30 GB de almacenamiento raíz
  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "MiWindowsTerraform"
  }
}
