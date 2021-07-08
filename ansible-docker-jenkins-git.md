```sh

# Enable the repository

sudo apt update
sudo apt upgrade # for very first time
sudo apt install git -y
git --version

# nginx installtion process

sudo apt install nginx -y 
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx


# ansible installtion process

sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
ansible --version

# Docksr installation process

sudo apt update
sudo apt wget install apt-transport-https ca-certificates curl gnupg lsb-release -y 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
    "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    (lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
systemctl restart docker
systemctl start docker
systemctl status docker


# Jenkins installation process

sudo apt install openjdk-8-jdk -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins -y
sudo systemctl status jenkins
sudo systemctl enable jenkins
sudo systemctl restart jenkins





```
