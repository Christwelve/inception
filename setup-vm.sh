#!/bin/bash


sudo apt update
sudo apt install -y make
sudo apt install -y curl

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo apt install -y docker-compose

# Verify installations
echo "Docker version:"
docker --version

echo "Docker Compose version:"
docker-compose --version

echo "curl version:"
curl --version