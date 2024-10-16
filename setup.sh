#!/bin/bash

# Meminta input dari pengguna
read -p "Masukkan domain/subdomain (contoh: example.com): " DOMAIN
read -p "Masukkan port aplikasi yang berjalan (contoh: 8000): " PORT

# Menginstall Nginx
sudo apt update
sudo apt install -y nginx

# Membuka port untuk Nginx dan SSH menggunakan UFW
echo "Membuka port untuk Nginx dan SSH..."
sudo ufw allow 'Nginx Full'
sudo ufw allow 'OpenSSH'
sudo ufw enable

# Membuat file konfigurasi Nginx
CONFIG_FILE="/etc/nginx/sites-available/$DOMAIN"

echo "Membuat konfigurasi Nginx untuk $DOMAIN..."

cat <<EOL | sudo tee $CONFIG_FILE
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://localhost:$PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOL

# Mengaktifkan konfigurasi Nginx
sudo ln -s $CONFIG_FILE /etc/nginx/sites-enabled/

# Menguji konfigurasi Nginx
if sudo nginx -t; then
    echo "Konfigurasi Nginx valid."
else
    echo "Konfigurasi Nginx tidak valid. Silakan periksa log."
    exit 1
fi

# Restart Nginx
sudo systemctl restart nginx

# Menginstall Certbot untuk SSL
echo "Menginstall Certbot untuk SSL..."
sudo apt install -y certbot python3-certbot-nginx

# Mengatur SSL
echo "Mengatur SSL untuk $DOMAIN..."
sudo certbot --nginx -d $DOMAIN

# Reload Nginx setelah mendapatkan sertifikat
sudo systemctl reload nginx

# Menampilkan pesan selesai
echo "Setup selesai! Akses website Anda di http://$DOMAIN dan https://$DOMAIN."
echo "Silakan arahkan DNS tipe A ke IP VPS Anda untuk domain $DOMAIN."
echo "Pastikan IP VPS Anda terdaftar di domain registrar."
