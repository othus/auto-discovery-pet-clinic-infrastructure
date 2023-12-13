#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum yum-utils -y
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y

# This configuration file will allow docker communicate with nexus over HTTP connection
sudo cat <<EOT>> /etc/docker/daemon.json
{
    "insecure-registries" : ["${var1}:8085"]
}
EOT

sudo usermod -aG docker ec2-user
sudo systemctl start docker
sudo systemctl enable docker 

curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-8GUFUP007XON26MGGRTZIQ04S55 NEW_RELIC_ACCOUNT_ID=3116346 /usr/local/bin/newrelic install

sudo hostnamectl set-hostname stage-instance