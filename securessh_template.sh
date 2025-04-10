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
