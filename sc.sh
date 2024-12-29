#!/bin/bash

# Tambahkan kunci SSH ke file authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGR43iKWlF1X249ibq8nocOusg2bwmpD8zHNtHmedXMo ebokey" >> ~/.ssh/authorized_keys

# Pastikan direktori dan file ada
mkdir -p ~/.ssh

# Berikan izin yang tepat untuk authorized_keys dan folder .ssh
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh

# Konfirmasi hasil
echo "Kunci SSH berhasil ditambahkan dan izin diperbarui."
