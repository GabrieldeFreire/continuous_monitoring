# Terraform - prometheus - Grafana
# Provision and deploy the Prometheus and Grafana on AWS using Terraform and Docker.
- [Introdução](#Introdução)
- [Pre-requisitos](#pre-requisitos)
- [Instalação e configuração](#Instalação-e-configuração)
- [Result](#Result)
- [Node Exporter](#Node Exporter)


# Introdução
Desenvolvido para utilização com a awsacademy.
Testado no ubuntu e linux-wsl2

# Pre-requisites
* Certifique-se de instalar a versão mais recente do [terraform](https://learn.hashicorp.com/terraform/getting-started/install.html)

# Instalação e configuração
Clone o projeto localmente

Se você gostaria de alterar quais alvos devem ser monitorados ou fazer alterações de configuração, edite o arquivo prometheus.yml.
A seção de alvos é onde você define o que deve ser monitorado pelo Prometheus (por padrão, monitora a própria instancia e a instancia com postgree)

O AWS provisionará e eles serão adicionados como uma parte das variáveis, se você deseja alterar, sinta-se à vontade para alterar apenas em variable.tf.
In this project we used the following provision.
* EC2 AMI - ami-053b0d53c279acc90 (Ubuntu Server 22.04)
* EC2 Instance Type - t2.micro
* Region - us-east-1
* VPC - 10.0.0.0/16
* Subnet - 10.0.1.0/24
* Port Opened - 3000, 9090

In this project the prometheus will discover the ec2 instance across the us-east-1 region.

# Steps to run the provisioning in terraform
1. Clone the repo
```
git clone https://github.com/ahamedyaserarafath/terraform_prometheus.git
```
2. Terraform initialize a working directory 
```
terraform init
```
3. Terraform to create an execution plan
```
terraform plan
```
4. Terraform apply to provision in aws
```
terraform apply
```
Note: The above command will provision the ec2 instance and install the prometheus

# Result
```
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

Grafana_URL = http://54.169.85.67:3000
Prometheus_URL = http://54.169.85.67:9090
```

# Node Exporter
Now Grafana and prometheus is up and running. Now its time to run the node-exporter in the ec2 nodes which will the send the metrics to prometheus.

```
cd node-exporter
./node_exporter.sh
```

Node exporter by default send the metrics in 9100 and now you can see those metrics in prometheus and grafana(is used only for ui dashboard)

