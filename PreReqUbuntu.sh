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

if verificar_instalacao "go" "GoLang"; then
    echo "GoLang já está instalado"
else
    echo "Baixando e instalando GoLang..."
    wget https://golang.org/dl/go1.22.4.linux-amd64.tar.gz^C
    sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
    source ~/.bashrc
fi

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

sudo chmod u+x /usr/local/bin/docker-compose

cd $HOME

printf "\n\nPersonalizando variáveis de ambiente\n"

echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
echo "export GOROOT=/usr/local/go" >> ~/.bashrc
echo "export PATH=$PATH:$GOROOT/bin" >> ~/.bashrc

echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bash_profile
echo "export GOROOT=/usr/local/go" >> ~/.bash_profile
echo "export PATH=$PATH:$GOROOT/bin" >> ~/.bash_profile

echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
echo "export GOROOT=/usr/local/go" >> ~/.profile
echo "export PATH=$PATH:$GOROOT/bin" >> ~/.profile

source ~/.bashrc
source ~/.bash_profile
source ~/.profile

printf "\n\nAmbiente configurado com sucesso\n"
