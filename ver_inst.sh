#!/bin/bash

# Verifica se o Node.js está instalado e mostra sua versão
if command -v node &> /dev/null; then
    echo "Versão do Node.js:"
    node --version
else
    echo "Node.js não está instalado. Por favor, instale o Node.js antes de continuar."
    exit 1
fi

# Verifica se o npm está instalado e mostra sua versão
if command -v npm &> /dev/null; then
    echo "Versão do npm:"
    npm --version
else
    echo "npm não está instalado. Por favor, instale o npm antes de continuar."
    exit 1
fi

# Verifica se o Docker está instalado e mostra sua versão
if command -v docker &> /dev/null; then
    echo "Versão do Docker:"
    docker --version
else
    echo "Docker não está instalado. Por favor, instale o Docker antes de continuar."
    exit 1
fi

# Verifica se o Docker-compose está instalado e mostra sua versão
if command -v docker-compose &> /dev/null; then
    echo "Versão do Docker-compose:"
    docker-compose version
else
    echo "Docker-compose não está instalado. Por favor, instale o Docker-compose antes de continuar."
    exit 1
fi

# Verifica se o Go está instalado e mostra sua versão
if command -v go &> /dev/null; then
    echo "Versão do Go:"
    go version
else
    echo "Go não está instalado. Por favor, instale o Go antes de continuar."
    exit 1
fi

# Se todas as verificações passarem, o ambiente está pronto para a Fabric
echo "Seu ambiente está pronto para a Hyperledger Fabric."
