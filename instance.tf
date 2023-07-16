
resource "aws_instance" "database_instance" {
  ami               = lookup(var.aws_amis, var.aws_region)
  instance_type     = var.aws_instance_type
  availability_zone = var.aws_availability_zone

  vpc_security_group_ids = ["${aws_security_group.prometheus_security_group.id}"]
  subnet_id              = aws_subnet.prometheus_subnet.id
  iam_instance_profile   = "LabInstanceProfile"
  key_name               = "vockey"

  connection {
    user        = "ubuntu"
    host        = self.public_ip
    password    = ""
    private_key = file("./labuser.pem")

  }

  # Copy labuser.pem
  provisioner "file" {
    source      = "./labuser.pem"
    destination = "/tmp/terraform-key.pem"
  }

  # Copy the node_exporter file to instance
  provisioner "file" {
    source      = "./node_exporter"
    destination = "node_exporter"
  }

  #   Install Database and node-exporter in the ubuntu
  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo \"deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main\" > /etc/apt/sources.list.d/pgdg.list'",
      "sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
      "sudo apt-get update",
      "sudo apt -y install postgresql postgresql-contrib",
      "sudo bash ./node_exporter/node_exporter.sh",
    ]
  }
 tags = {
    Name        = "${var.database_server_name}_instance"
    Environment = "${var.env}"
  }
}

# prometheus grafana instance
resource "aws_instance" "prometheus_instance" {
  ami               = lookup(var.aws_amis, var.aws_region)
  instance_type     = var.aws_instance_type
  availability_zone = var.aws_availability_zone

  vpc_security_group_ids = ["${aws_security_group.prometheus_security_group.id}"]
  subnet_id              = aws_subnet.prometheus_subnet.id
  iam_instance_profile   = "LabInstanceProfile"
  key_name               = "vockey"

  connection {
    user        = "ubuntu"
    host        = self.public_ip
    password    = ""
    private_key = file("./labuser.pem")

  }

  # Copy labuser.pem
  provisioner "file" {
    source      = "./labuser.pem"
    destination = "/tmp/terraform-key.pem"
  }

  # Copy the prometheus file to instance
  provisioner "file" {
    source      = "./prometheus"
    destination = "prometheus"
  }

  # Copy the node_exporter file to instance
  provisioner "file" {
    source      = "./node_exporter"
    destination = "node_exporter"
  }

  # Copy the grafana file to instance
  provisioner "file" {
    source      = "./grafana.sh"
    destination = "./grafana.sh"
  }

  # Install Prometheus, node-exporter and grafana in the ubuntu
  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's;<database_instance_private_ip>;${aws_instance.database_instance.private_ip};g' ./prometheus/prometheus.yml",
      "sudo bash ./prometheus/prometheus.sh",
      "sudo bash ./node_exporter/node_exporter.sh",
      "sudo bash ./grafana.sh",
    ]
  }

  tags = {
    Name        = "${var.monitoring_server_name}_instance"
    Environment = "${var.env}"
  }
}
