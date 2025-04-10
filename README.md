# 🔐 Secure SSH Launcher with GPG & 2FA

A security-first login system for SSH that uses **multiple encrypted layers** and **Google Authenticator** to protect your remote access credentials.

This project lets you securely store your SSH private key and 2FA secret using GPG and OpenSSL, requiring two passwords and a 2FA code to initiate the login.  
It generates unique login scripts per server — ideal for managing multiple services securely.

---

## 📁 Structure

secure-ssh-launcher/ ├── encryptfiles.sh # Encrypts your .pem and 2FA secrets ├── generate_launcher.sh # Generates secure launcher per server ├── templates/ │ └── securessh_template.sh # Encrypted base logic for login ├── login/ │ └── server1/ │ ├── login_server1.sh │ └── securessh_server1.sh.gpg └── README.md

yaml
Copy
Edit

---

## 🚀 Quick Start

### 1. 🔐 Encrypt your credentials

```bash
./encryptfiles.sh path/to/key.pem path/to/google_auth.key
You’ll set:

Password 1 → For the Google Authenticator secret

Password 2 → For your SSH private key

2. 🛠️ Generate your secure login
bash
Copy
Edit
./generate_launcher.sh --server server1 --ip 123.123.123.123 --user ubuntu
This creates:

login/server1/login_server1.sh → Secure login script

login/server1/securessh_server1.sh.gpg → Encrypted login logic

3. 🔑 Use your login
bash
Copy
Edit
cd login/server1
./login_server1.sh
You’ll be prompted for:

Password 1 (to decrypt 2FA secret)

Your 6-digit Google Authenticator code

Password 2 (to decrypt the .pem file)

🧠 How it works
Each login flow:

Decrypts your 2FA key

Prompts for 2FA token

Decrypts your SSH private key

Initiates a secure SSH connection

No credentials are ever stored unencrypted.

🧪 Testing (Demo Mode)
You can simulate the process using example .pem and .key files without needing to actually connect to a server.

📄 License
MIT — feel free to fork and adapt.

💡 Ideas to Contribute?
Add biometric/face auth support (macOS/Linux)

Integration with other 2FA providers

Add web dashboard to manage servers
