#!/bin/bash
# Script to automatically update ansible host inventory 

AWSCLI='/usr/local/bin/aws'
awsDiscovery() {
        \$AWSCLI ec2 describe-instances  --filters Name=tag:aws:autoscaling:groupName,Values=petclinic-stage-asg \\
                --query Reservations[*].Instances[*].NetworkInterfaces[*].{PrivateIpAddrress} > /etc/ansible/prod-ips.list
}
inventoryUpdate() {
    echo "[webservers]" > /etc/ansible/stage-hosts
    for instance in \'cat /etc/ansible/stage-ips.list\'
    do
            ssh-keyscan -H \$instance >> ~/.ssh/know_hosts
    echo "\$instance ansible_user=ec2-user ansible_ssh_private_key_file=/etc/ansible/key.pem" >> /etc/ansible/stage-hosts
    done
}
instanceUpdate() {
    sleep 30
    ansible-playbook /etc/ansible/stage-env-playbook.yml --extra-vars "ansible_python_interpreter=/usr/bin/python3.9"
    sleep 30
}

awsDiscovery
inventoryUpdate
instanceUpdate