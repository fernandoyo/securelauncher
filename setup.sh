#!/bin/bash

echo "🔐 Running securelauncher setup..."

# Criação da pasta de logins
mkdir -p logins

# 1. Gerar chave privada exemplo
if [ ! -f "logins/example.pem" ]; then
    echo "🔑 Generating example PEM key..."
    openssl genrsa -out logins/example.pem 2048
fi

# 2. Gerar segredo para Google Authenticator (base32, 16 caracteres)
GOOGLE_SECRET=$(cat /dev/urandom | tr -dc 'A-Z2-7' | fold -w 16 | head -n 1)
echo "🧩 Google Auth secret (save in your app): $GOOGLE_SECRET"
echo "$GOOGLE_SECRET" > logins/google_secret.txt

# 3. Criar securessh_template.sh se não existir
if [ ! -f "securessh_template.sh" ]; then
    cat << 'EOF' > securessh_template.sh
#!/bin/bash

echo "🔐 Step 1: Enter password 1"
gpg -d google_auth.asc.gpg > google_temp 2>/dev/null || { echo "❌ Wrong password 1"; exit 1; }

echo "🔢 Step 2: Enter 2FA code"
read -p "Code: " CODE
REAL_CODE=$(oathtool --totp -b $(cat google_temp))

if [ "$CODE" != "$REAL_CODE" ]; then
    echo "❌ Invalid 2FA code"
    rm -f google_temp
    exit 1
fi
rm -f google_temp

echo "🔐 Step 3: Enter password 2"
openssl aes-256-cbc -d -in $PEM_FILE.enc -out temp_key.pem || { echo "❌ Wrong password 2"; exit 1; }

chmod 400 temp_key.pem
echo "🟢 Logging in..."
ssh -i temp_key.pem $SSH_USER@$SSH_IP
rm -f temp_key.pem
EOF

    chmod +x securessh_template.sh
    echo "✅ Template created: securessh_template.sh"
fi

# 4. Criar generate_launcher.sh se não existir
if [ ! -f "generate_launcher.sh" ]; then
    cat << 'EOF' > generate_launcher.sh
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
EOF

    chmod +x generate_launcher.sh
    echo "✅ Launcher generator created: generate_launcher.sh"
fi

echo "🎉 Setup complete. Run './generate_launcher.sh' to create your secure login."

