#!/bin/bash
sudo apt update
sudo apt install -y wget unzip
sudo wget https://releases.hashicorp.com/consul/1.7.3/consul_1.7.3_linux_amd64.zip
sudo unzip consul_1.7.3_linux_amd64.zip
sudo mv consul /usr/bin/
sudo cat <<EOT>> /etc/systemd/system/consul.service
[Unit]
Description=consul
Documentation=http://www.consul.io

[Service]
ExecStart=/usr/bin/consul agent -server -ui -data-dir=/temp/consul bootstrap-expect=1 -node=vault -bind=$(hostname -i) -config-dir=/etc/consul.d/
ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT

sudo mkdir /etc/consul.d
sudo cat <<EOT>> /etc/consul.d/ui.json
{
    "adresses":{
        "http": "0.0.0.0"
    }
}
EOT

sudo systemctl daemon-reload
sudo systemctl start consul
sudo systemctl enable consul
sudo apt update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo apt-get install -y certbot
sudo certbot certonly --standalone -d "${var3}" --email "${var4}" --agree-tos --non-interactive
sudo wget https://releases.hashicorp.com/vault/1.5.0/vault_1.5.0_linux_amd64.zip
sudo unzip vault_1.5.0_linux_amd64.zip
sudo mv vault /usr/bin/
sudo mkdir /etc/vault/
sudo cat <<EOT>> /etc/vault/config.hcl
storage "consul" {
    adress = "127.0.0.1:8500"
    path = "vault/"
}
listener "tcp" {
    adress = "0.0.0.0:443"
    tls_disable = 0
    tls_cert_file = "/etc/letsencrypt/live/${var3}/fullchain.pem
    tls_key_file = "/etc/letsencrypt/live/${var3}/privkey.pem
}
seal "awskms" {
    region = "${var1}"
    kms_key_id = "${var2}"
}
ui =true
EOT

sudo cat <<EOT>> /etc/systemd/system/vault.service
[Unit]
Description=Vault
Documentation=http://www.vault.io

[Service]
ExecStart=/usr/bin/vault server -config-dir=/etc/vault/config.hcl
ExecReload=/bin/kill -HUP $MAINPID
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOT

sudo systemctl Daemon-reload
export VAULT_ADDR=http://${var3}:443
cat << EOT > /etc/profile.d/vault.sh
export VAULT_ADDR=http://${var3}:443
export VAULT_SKIP_VERIFY=true
EOT
vault -autocomplete-install
complete -C /usr/bin/vault vault
sudo systemctl start vault
sudo systemctl enable vault

sudo hostnamectl set-hostname Vault