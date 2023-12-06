profilename = "raroaccess"

aws-region = "us-east-1"

path-to-key-file ="~/keypairs/Pap_key"

vault-ami = "ami-0fc5d935ebf8bc3bc"

instance_type = "t2-micro"

domain-name = aws_instance.vault-server.public_dns

email = "raroetobro@gmail.com"

vault-kms-key = aws_kms_key.vault-kms-key.id