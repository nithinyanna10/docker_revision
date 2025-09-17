#!/bin/bash

# Docker Installation Script for Ubuntu/Debian
# This script installs Docker Engine and Docker Compose

set -e

echo "🐳 Docker Installation Script"
echo "=============================="

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo "❌ This script should not be run as root for security reasons"
   echo "   Please run as a regular user with sudo privileges"
   exit 1
fi

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    echo "✅ Docker is already installed: $(docker --version)"
    read -p "Do you want to reinstall? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
fi

# Update package index
echo "📦 Updating package index..."
sudo apt-get update

# Install required packages
echo "📦 Installing required packages..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Add Docker's official GPG key
echo "🔑 Adding Docker's official GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "📋 Adding Docker repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again
echo "📦 Updating package index with Docker repository..."
sudo apt-get update

# Install Docker Engine
echo "🐳 Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add current user to docker group
echo "👤 Adding user to docker group..."
sudo usermod -aG docker $USER

# Enable Docker to start on boot
echo "🚀 Enabling Docker to start on boot..."
sudo systemctl enable docker

# Start Docker service
echo "▶️  Starting Docker service..."
sudo systemctl start docker

# Verify installation
echo "✅ Verifying installation..."
if docker --version &> /dev/null; then
    echo "✅ Docker installed successfully: $(docker --version)"
else
    echo "❌ Docker installation failed"
    exit 1
fi

if docker compose version &> /dev/null; then
    echo "✅ Docker Compose installed successfully: $(docker compose version)"
else
    echo "❌ Docker Compose installation failed"
    exit 1
fi

# Test Docker with hello-world
echo "🧪 Testing Docker with hello-world container..."
if sudo docker run hello-world &> /dev/null; then
    echo "✅ Docker test successful!"
else
    echo "❌ Docker test failed"
    exit 1
fi

echo ""
echo "🎉 Docker installation completed successfully!"
echo ""
echo "⚠️  Important: You need to log out and log back in for group changes to take effect."
echo "   Or run: newgrp docker"
echo ""
echo "📚 Next steps:"
echo "   1. Log out and log back in (or run 'newgrp docker')"
echo "   2. Test with: docker run hello-world"
echo "   3. Continue with the Docker A2Z learning path"
echo ""
echo "🔧 Useful commands:"
echo "   docker --version          # Check Docker version"
echo "   docker info               # System information"
echo "   docker run hello-world    # Test Docker"
echo "   docker ps                 # List running containers"
echo "   docker images             # List images"
