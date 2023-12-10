locals {
  nexus_user_data = <<-EOF
#!/bin/bash
sudo yum update
sudo yum install -y wget java-1.8.0-openjdk.x86_64
sudo mkdir /app && cd /app
sudo wget https://download.sonatype.com/nexus/3/nexus-3.23.0-03-unix.tar.gz
sudo tar -xvf nexus-3.23.0-03-unix.tar.gz
sudo mv nexus-3.23.0-03 nexus
sudo adduser nexus
sudo chown -R nexus:nexus /app/nexus
sudo chown -R nexus:nexus /app/sonatype-work
sudo cat <<EOT> /app/nexus/bin/nexus.rc
run_as_user="nexus"
EOT
sed -i '2s/-Xms2703m/-Xms512m/' /app/nexus/bin/nexus.vmoptions
sed -i '3s/-Xms2703m/-Xms512m/' /app/nexus/bin/nexus.vmoptions
sed -i '4s/-XX:MaxDirectMemorySize=2703m/-XX:MaxDirectMemorySize=512m/' /app/nexus/bin/nexus.vmoptions
sudo touch /etc/systemd/system/nexus.service
sudo cat <<EOT> /etc/systemd/system/nexus.service
[Unit]
Desription=nexus service
After=network.target
[service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/app/nexus/bin/nexus start
ExecStop=/app/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOT
sudo ln -s app/nexus/bin/nexus /etc/init.d/nexus
sudo chkconfig --add nexus
sudo chkconfig --levels 345 nexsu on
sudo service nexus start
# install Newrelic monitoring agent

sudo hostnamectl -set-hostname Nexus
  EOF
}