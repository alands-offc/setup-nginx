# Setup Nginx dan SSL di VPS

## Deskripsi
Script ini digunakan untuk mengkonfigurasi Nginx dan SSL di VPS Anda. Script ini juga akan membuka port yang diperlukan untuk Nginx dan SSH, serta memberikan instruksi untuk mengarahkan DNS.

## Prerequisites
- Anda memiliki akses root ke VPS.
- Domain telah terdaftar dan dapat diubah DNS-nya.

## Cara Instalasi

Anda dapat mengunduh dan menjalankan script langsung menggunakan `curl` dengan perintah berikut:

```bash
curl -O https://raw.githubusercontent.com/alands-offc/setup-nginx/main/setup.sh
chmod +x setup.sh
./setup.sh
