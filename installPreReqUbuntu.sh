printf "Instalando Artefatos de Construção\n\n"

sudo apt -y update && sudo apt -y upgrade

sudo apt -y install build-essential

printf "\n\nInstalando GoLang\n"

GO_VERSION=$(curl -sSL https://golang.org/dl/ | grep -o 'go[0-9.]*linux-amd64.tar.gz' | head -n 1)

sudo curl -fsSL https://golang.org/dl/$GO_VERSION --output $GO_VERSION

sudo rm -rf /opt/go

sudo tar -C /opt -xvzf $GO_VERSION

mkdir -p $HOME/go

echo "Instalando Node.js..."

# Adicionando o repositório do Node.js e a chave GPG
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Atualizando o cache do apt
sudo apt update

# Instalando o Node.js e o npm
sudo apt install -y nodejs

# Exibindo a versão do Node.js e do npm instalados
echo "Node.js $(node -v)"
echo "npm $(npm -v)"

echo "Node.js instalado com sucesso!"

printf "\n\nInstalando Docker\n"

# Instalando Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh

printf "\n\nReiniciando Docker\n"

sudo usermod -aG docker $(whoami)

sudo grpck

sudo grpconv

newgrp docker << END

sudo systemctl restart docker.service

printf "\n\nInstalando Docker-Compose\n"

DOCKER_COMPOSE_VERSION=$(curl -sSL https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d'"' -f4)

sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

rm -f $GO_VERSION get-docker.sh

cd $HOME

printf "\n\nPersonalizando variáveis de ambiente\n"

echo "export GOPATH=$HOME/go" >> ~/.bashrc

echo "export GOROOT=/opt/go" >> ~/.bashrc

source ~/.bashrc

printf "\n\nAmbiente configurado com sucesso\n"

END

newgrp docker
