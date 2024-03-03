# Update the system
sudo apt-get update
sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install make curl lsb-release ca-certificates apt-transport-https software-properties-common -y

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Set up the Docker repository for Debian
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index
sudo apt-get update

# Install Docker Engine and CLI
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Install Docker Compose as a Docker plugin (Check Docker documentation for the most current method)
# This command assumes Docker Compose V2 is being installed as part of the Docker installation
# sudo docker compose version

# Alternatively, for Docker Compose V1 (if necessary)
# sudo apt-get install docker-compose -y

# # Install Git
# sudo apt-get install git -y

# Clean up the apt cache
sudo apt-get clean

# Verify installation
echo "Docker version:"
docker --version

echo "Docker Compose version:"
docker compose version

echo "Git version:"
git --version