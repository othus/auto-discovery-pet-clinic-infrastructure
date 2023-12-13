locals {
  jenkins_user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum upgrade -y
sudo yum install -y wget git maven
sudo yum install java_11-openjdk -y
sudo wget https://get.jenkins.io/redhat/jenkins-2.411-1.1.noarch.rpm
sudo rpm -ivf jenkins-2.411-1.1.noarch.rpm
sudo yum update -y
sudo yum install jenkins -y
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo yum yum-utils -y
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker jenkins
sudo usermod -aG docker ec2-user
sudo chmod 777 /var/run/docker.sock
sudo cat <<EOT>> /etc/docker/daemon.json
{
    "insecure-registries" : ["${var.nexus_ip}:8085"]
}
EOT
sudo systemctl restart docker 

# Install Newrelic agent
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-8GUFUP007XON26MGGRTZIQ04S55 NEW_RELIC_ACCOUNT_ID=3116346 /usr/local/bin/newrelic install

sudo hostnamectl set-hostname jenkins
EOF
}