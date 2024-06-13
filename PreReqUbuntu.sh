#!/bin/bash

# Função para verificar se uma aplicação está instalada
verificar_instalacao() {
    comando=$1
    nome=$2
    # Verifica se a aplicação está instalada
    if command -v $comando &> /dev/null; then
        return 0  # Retorna 0 se a aplicação está instalada
    else
        return 1  # Retorna 1 se a aplicação não está instalada
    fi
}

printf "Instalando Artefatos de Construção\n\n"

sudo apt -y update && sudo apt -y upgrade

# Verifica e instala build-essential se necessário
if verificar_instalacao "gcc" "build-essential"; then
    echo "build-essential já está instalado"
else
    echo "Instalando build-essential..."
    sudo apt -y install build-essential
fi

printf "\n\nInstalando GoLang\n"

GO_VERSION=$(curl -sSL https://golang.org/dl/ | grep -o 'go[0-9.]*linux-amd64.tar.gz' | head -n 1)

if verificar_instalacao "go" "GoLang"; then
    echo "GoLang já está instalado"
else
    echo "Baixando e instalando GoLang..."
    GO_VERSION=$(curl -sSL https://golang.org/dl/ | grep -o 'go[0-9.]*linux-amd64.tar.gz' | head -n 1)
    sudo curl -fsSL https://golang.org/dl/$GO_VERSION --output $GO_VERSION
    sudo rm -rf /usr/local/go  # Remove a instalação anterior do Go, se houver
    sudo tar -C /usr/local -xvzf $GO_VERSION  # Extraia o arquivo tar.gz para /usr/local
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    source ~/.bashrc
fi

mkdir -p $HOME/go

echo "Instalando Node.js..."

# Adicionando o repositório do Node.js e a chave GPG
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_14.x $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Atualizando o cache do apt
sudo apt update

# Verifica e instala npm e Node.js se necessário
if verificar_instalacao "npm" "npm"; then
    echo "npm já está instalado"
else
    echo "Instalando npm..."
    sudo apt-get install npm
fi

if verificar_instalacao "node" "Node.js"; then
    echo "Node.js já está instalado"
else
    echo "Instalando Node.js..."
    sudo apt install -y nodejs
fi

# Exibindo a versão do Node.js e do npm instalados
echo "Node.js $(node -v)"
echo "npm $(npm -v)"

printf "\n\nInstalando Docker....\n"

# Verifica e instala Docker se necessário
if verificar_instalacao "docker" "Docker"; then
    echo "Docker já está instalado"
else
    echo "Instalando Docker..."
    sudo apt update
    sudo apt upgrade
    sudo apt-get install  curl apt-transport-https ca-certificates software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update
    sudo apt install docker-ce
    sudo systemctl restart docker
    printf "\n\nReiniciando Docker\n"
fi

# Adiciona o usuário atual ao grupo docker
sudo usermod -aG docker $(whoami)

# Instala o Docker-Compose
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
