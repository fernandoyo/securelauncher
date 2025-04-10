README.md
markdown
Copy
Edit
# SecureLauncher 🔐

SecureLauncher is a minimal and smart script-based system to safely manage SSH access to multiple remote servers using:

- 🔑 Encrypted `.pem` keys with OpenSSL
- 🧩 Optional 2FA with Google Authenticator (TOTP)
- 🗝️ GPG-encrypted scripts and secrets
- 🧠 Clean login flow using sequential password protection (Password 1, 2FA code, Password 2)

---

## 📁 Folder Structure

Each server should have its own folder inside the `logins/` directory:

logins/ ├── server1/ │ ├── google.txt # Your Google Auth secret key (TOTP) │ ├── server.pem # Your original SSH key (unencrypted) │ ├── securessh-template.sh # Secure SSH script logic (reused for all) │ └── generate_launcher.sh # Used to generate the encrypted launcher

yaml
Copy
Edit

---

## 🛠️ First Time Setup

Run the following script to generate example files and guide you through the process of setting up the launcher:

```bash
./setup.sh
This will:

Help create .pem and google.txt files

Encrypt the .pem file using OpenSSL

Encrypt the Google secret key using GPG

Generate a secure securessh.sh.gpg script

Build a launcher called login.sh to start the session securely

🔓 Using the Launcher
Once the setup is complete, simply:

bash
Copy
Edit
cd logins/server1/
./login.sh
You’ll be prompted to:

Enter Password 1 (to decrypt the 2FA key)

Enter your Google Authenticator code

Enter Password 2 (to decrypt the SSH key)

Automatically SSH into the remote server using your .pem

🔄 Creating Additional Server Logins
You can create separate secure login folders for each server. For example:

bash
Copy
Edit
cp -r logins/server1 logins/server2
Update the IP, username, and file names in the new folder, then re-run generate_launcher.sh.

✅ Requirements
gpg

openssl

ssh

Optional: oathtool (for local 2FA code validation)

⚠️ Disclaimer
This project is for educational purposes. Please audit any script and customize it according to your security model. Never share your encrypted files or secrets.

💡 Contribution
Pull requests are welcome. Feel free to open issues to suggest new features or improvements.

License
MIT
