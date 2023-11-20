variable "instancias" {
  description = "Nombre de las instancias"
  type = list(string)
  default = ["apache"]  
  }

resource "aws_instance" "public_instance" {
for_each = toset(var.instancias)
#count = length(var.instancias)
ami           = var.ec2_specs.ami
instance_type = var.ec2_specs.instance_type
subnet_id     = aws_subnet.public_subnet.id
key_name      = data.aws_key_pair.key.key_name
vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
user_data = file("scripts/userdata.sh")

tags = {
  #"Name" = var.instancias[count.index]
  "Name" = "${each.value}-${local.sufix}"
}
}
variable "cadena" {
  type = string
  default = "ami-123,AMI-AAV,ami-12f"
}

resource "aws_instance" "monitoring_instance" {
#for_each = toset(var.instancias)
count = var.enable_monitoring == 1 ? 1 : 0
ami           = var.ec2_specs.ami
instance_type = var.ec2_specs.instance_type
subnet_id     = aws_subnet.public_subnet.id
key_name      = data.aws_key_pair.key.key_name
vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
user_data = file("scripts/userdata.sh")

tags = {
   "Name" = "Monitoreo-${local.sufix}"
}
}
