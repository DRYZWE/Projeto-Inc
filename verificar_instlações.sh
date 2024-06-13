#!/bin/bash

# Verifica se o Node.js está instalado e mostra sua versão
if command -v node &> /dev/null; then
    echo "Versão do Node.js:"
    node --version
else
    echo "Node.js não está instalado"
fi

# Verifica se o npm está instalado e mostra sua versão
if command -v npm &> /dev/null; then
    echo "Versão do npm:"
    npm --version
else
    echo "npm não está instalado"
fi

# Verifica se o Docker está instalado e mostra sua versão
if command -v docker &> /dev/null; then
    echo "Versão do Docker:"
    docker --version
else
    echo "Docker não está instalado"
fi

# Verifica se o Go e suas dependencias estão instaladas e mostra sua versão
if command -v go &> /dev/null; then
    echo "Versão do Go:"
    go version
else
    echo "Go não está instalado"
fi
