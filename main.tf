#Configuracion del proveedor de AWS
provider "aws" {
  region = "us-east-1" #region donde se desplegaran los recursos
}
#Creamos el security group
resource "aws_security_group" "mi-sg" {
  name        = "mi-security-group-terraform"
  description = "Security group para mi instancia de Terraform"
  vpc_id      = "vpc-0098cc45777949af0" #ID de la VPC donde se creara el security group

  #reglas de entrada para SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #reglas de salida para HTTP
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
#declaracion de los recursos de AWS

resource "aws_instance" "mi_instancia_2" {
  ami           = "ami-0c230065b91270bc6" #AMI de Amazon Linux 2023
  instance_type = "t2.micro"              #tipo de instancia
  key_name      = "mi-primera-llaves-lr"  #nombre del par de claves para acceder a la instancia
  
  tags = {
    Name = "MiInstanciaTerraform2"
  }
  vpc_security_group_ids = [aws_security_group.mi-sg.id] #asignamos el security group creado anteriormente

}
