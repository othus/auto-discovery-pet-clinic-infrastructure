locals {
  sonarqube_user_data = <<-EOF
#!/bin/bash
sudo apt update -y

sudo bash -c 'echo "
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096" >> /etc/sysctl.conf'

sudo bash -c 'echo "
sonarqube - nofile 65536
sonarqube - nproc 4098" >> /etc/security/limits.conf

sudo apt install -y unzip openjdk-11-jdk

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ lsb_release -cs-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install postgresql-12 postgresql-contrib-12
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo chpasswd <<<"postgres:Admin123@
sudo su -c 'createuser sonar' postgres
sudo su -c "psql -c \"ALTER USER sonar WITH ENCRYPTED PASSWORD 'Admin123@'\"" postgres
sudo su -c "psql -c \"CREATE DATABASE sonarqube OWNER sonar\"" postgres
sudo su -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar\"" postgres
sudo systemctl restart postgresql

sudo mkdir /sonarqube/
sudo cd /sonarqube/
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.6.0.39681.zip
sudo unzip sonarqube-8.6.0.39681.zip -d /opt/
sudo mv /opt/sonarqube-8.6.0.39681 /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "SonarQube -User" -d /opt/sonarqube/ -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube/ -R
sudo bash -c 'echo "
sonar.jdbc.username=sonar
sonar.jdbc.password=Admin123@
sonar,jbdc.url=jbdc:postgresql://localhost/sonarqube
sonar.search.javOpts=-Xmx512 -Xms512 -XX:+HeapDumpOnOutOfMemoryError" >> /opt/sonarqube/conf/sonar.properties'
sudo touch /etc/systemd/system/sonarqube.service
sudo bash -c 'echo "
[Unit]
Desription=SonarQube service
After=syslog.target network.target
[service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x84-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x84-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096
[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/sonarqube.service'
sudo systemctl daemon-reload
sudo systemctl enable sonarqube.service
sudo systemctl start sonarqube.service

sudo apt install net-tools -y
sudo apt-get install nginx -y
sudo touch /etc/nginx/sites-enabled/sonarqube.conf
sudo bash -c 'echo "
server{
    listen 80;
    access_log /var/log/nginx/sonar.access.log;
    error_log /var/log/nginx/sonar.error.log;
    proxy_buffer 16 64k;
    proxy_buffer_size 128k;
    location / {
        proxy_pass http://127.0.0.1:9000;
        proxy__next_upstreamerror timeout invalid_header Http_500 Http_502 Http_503 Http_504;
        proxy_redirect off;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forworded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forworded-Proto http;
    }
}" >> /etc/nginx/sites-enabled/sonarqube.conf

sudo rm //etc/nginx/sites-enabled/default
sudo systemctl enable nginx.service
sudo systemctl stop nginx.service
sudo systemctl start nginx.service

curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo NEW_RELIC_API_KEY="${var.newrelic_license_key}" NEW_RELIC_ACCOUNT_ID="${var.acct_id}" /usr/local/bin/newrelic install

sudo hostnamectl -set-hostname Sonarqube
sudo reboot

EOF
}