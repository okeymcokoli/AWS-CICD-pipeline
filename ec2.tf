#Provisioning test ec2
resource "aws_instance" "my-first-server" {
  provider = aws.audit-account
  ami             = "ami-040e3653819aaddc1"
  instance_type   = "t2.micro"
  
tags = {
  Name = "MyFirstServer"
} 
  
}

##adding security gruops
resource "aws_security_group" "main" {
   name   = var.sg_name

   dynamic "ingress" {
       for_each = var.ingress_rules

       content {
           description = ingress.value.description
           from_port   = ingress.value.from_port   
           to_port     = ingress.value.to_port     
           protocol    = "tcp"
           cidr_blocks = ["0.0.0.0/0"]
       }
   }
}