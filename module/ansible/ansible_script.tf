locals {
  ansible_user_data = <<-EOF
#!/bin/bash/

sudo yum update -y
sudo yum install wget unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -svf /usr/local/bin/aws usr/bin/aws
sudo bash -c 'echo "strictHostKeyChecking No" >> /etc/ssh/ssh_config'

# Configure aws cli and export access key & id as an ENV variable
sudo su -c "aws configure set aws_access_key_id ${aws_iam_access_key.ansible_user_key.id}" ec2-user
sudo su -c "aws configure set aws_secret_key_key ${aws_iam_access_key.ansible_user_key.secret}" ec2-user
sudo su -c "aws configure set default.region us-east-1" ec2-user
sudo su -c "aws configure set default.output text" ec2-user
export AWS_ACCESS_KEY_ID=${aws_iam_access_key.ansible_user_key.id}
export AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.ansible_user_key.secret}

# Install ansible
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum update -y
sudo yum install python python-devel python-pip ansible -y
sudo echo "${file(var.staging_playbook)}" >> /etc/ansible/stage-env-playbook.yml
sudo echo "${file(var.prod_playbook)}" >> /etc/ansible/prod-env-playbook.yml
sudo echo "${file(var.staging_discovery_script)}" >> /etc/ansible/stage-env-bash-script.yml
sudo echo "${file(var.prod_discovery_script)}" >> /etc/ansible/prod-env-bash-script.yml
sudo echo "${file(var.keypair)}" >> /etc/ansible/key.pem
sudo bash -c 'echo "NEXUS_IP: ${var.nexus_ip}:8085" > /etc/ansible/ansible_vars_file.yml'
sudo chown -R ec2-user:ec2-user /etc/ansible
sudo chmod 400 /etc/ansible/key.pem

# Creating crontab for auto discovery script
echo "*/15 * * * * ec2-user sh /etc/ansible/stage-env-bash-script.sh" > /etc/crontab
echo "*/15 * * * * ec2-user sh /etc/ansible/prod-env-bash-script.sh" >> /etc/crontab

# Install Newrelic agent
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY=NRAK-8GUFUP007XON26MGGRTZIQ04S55 NEW_RELIC_ACCOUNT_ID=3116346 /usr/local/bin/newrelic install

sudo hostnamectl set-hostname ansible
EOF
}