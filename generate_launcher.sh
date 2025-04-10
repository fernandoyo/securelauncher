#!/bin/bash

read -p "Enter PEM filename (inside logins/): " pem_name
read -p "Enter SSH username: " ssh_user
read -p "Enter server IP or domain: " ssh_ip
read -p "Enter a nickname for this server (e.g. server1): " nickname

# Encrypt the .pem file
openssl aes-256-cbc -salt -in logins/$pem_name -out logins/$pem_name.enc

# Copy and customize the securessh template
cp securessh_template.sh logins/securessh_$nickname.sh

# Replace variables
sed -i "s|\$PEM_FILE|$pem_name|g" logins/securessh_$nickname.sh
sed -i "s|\$SSH_USER|$ssh_user|g" logins/securessh_$nickname.sh
sed -i "s|\$SSH_IP|$ssh_ip|g" logins/securessh_$nickname.sh

# Encrypt google secret (for demonstration)
gpg -o logins/google_auth.asc.gpg -c logins/google_secret.txt

echo "✅ Launcher ready: logins/securessh_$nickname.sh"
