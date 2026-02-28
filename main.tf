provider "aws" {
    region = var.region
}
# Create VPC
resource "aws_vpc" "sandbox_vpc" {
    cidr_block = "10.0.0.0/16"
}
# Subnet
resource "aws_subnet" "sandbox_subnet" {
    vpc_id                                  = aws_vpc.sandbox_vpc.id
    cidr_block                              = "10.0.1.0/24"
    map_public_ip_on_launch                 = true
}
# Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.sandbox_vpc.id
}

# Route Table
resource "aws_route_table" 	"public" {
    vpc_id = aws_vpc.sandbox_vpc.id
}
resource "aws_route" 	"internet_access" {
    route_table_id         = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" 	"public_assoc" {
    subnet_id      = aws_subnet.sandbox_subnet.id
    route_table_id = aws_route_table.public.id
}
# Security Group
resource "aws_security_group" "sandbox_sg" {
    name = "sandbox-sg"
    vpc_id = aws_vpc.sandbox_vpc.id

ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
}
ingress {
   from_port   = 8080
   to_port     = 8080
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
}
egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create SSH key
resource "tls_private_key" "ssh_key" {
    algorithm   = "RSA"
    rsa_bits    = 4096
}
resource "aws_key_pair" "generated_key" {
    key_name = "sandbox-key"
    public_key = tls_private_key.ssh_key.public_key_openssh
}
# Save private key locally
resource "local_file" "private_key" {
    content   = tls_private_key.ssh_key.public_key_pem
    filename = "sandbox-key.pem" 
}
# EC2 Instance
resource "aws_instance" "sandbox_vm" {
    ami                         =  "ami-01794c3812ef4f99a" # Ubuntu (us-east-1)
    instance_type               = "t2.micro"
    subnet_id                   = aws_subnet.sandbox_subnet.id
    vpc_security_group_ids      = [aws_security_group.sandbox_sg.id]
    key_name                    = aws_key_pair.generated_key.key_name
    associate_public_ip_address = true

connection {
    type              = "ssh"
    user              = "ubuntu"
    private_key = tls_private_key.ssh_key.private_key_pem
    host              = self.public_ip
  }
provisioner "remote-exec" {
    inline = [
       " sudo apt update -y",
       " sudo apt install python3 -y"
]

}
provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ansible/inventory.ini ansible/playbook.yml - -private-key sandbox-key.pem -u admin"
 }
}


