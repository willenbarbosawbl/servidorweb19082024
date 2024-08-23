#!/bin/bash

# Função para atualizar a lista de pacotes
atualizar_lista_pacotes() {
    echo "Atualizando a lista de pacotes..."
    sudo apt-get update
    echo "Lista de pacotes atualizada com sucesso!"
}

# Função para atualizar os pacotes instalados
atualizar_pacotes() {
    echo "Atualizando os pacotes instalados..."
    sudo apt-get upgrade -y
    echo "Pacotes atualizados com sucesso!"
}

# Função para atualizar a distribuição
atualizar_distribuicao() {
    echo "Atualizando a distribuição..."
    sudo apt-get dist-upgrade -y
    echo "Distribuição atualizada com sucesso!"
}

# Função para limpar pacotes desnecessários
limpar_sistema() {
    echo "Limpando pacotes desnecessários..."
    sudo apt-get autoremove -y
    sudo apt-get autoclean
    echo "Sistema limpo com sucesso!"
}

# Função para corrigir pacotes quebrados
corrigir_erros() {
    echo "Corrigindo pacotes quebrados..."
    sudo apt-get install -f -y
    echo "Pacotes quebrados corrigidos!"
}

# Função para executar todas as operações de uma vez
atualizar_completo() {
    atualizar_lista_pacotes
    atualizar_pacotes
    atualizar_distribuicao
    corrigir_erros
    limpar_sistema
    echo "Atualização completa realizada com sucesso!"
}

# Menu de opções
while true; do
    echo "Selecione uma opção:"
    echo "1) Atualizar a lista de pacotes"
    echo "2) Atualizar os pacotes instalados"
    echo "3) Atualizar a distribuição"
    echo "4) Corrigir pacotes quebrados"
    echo "5) Limpar pacotes desnecessários"
    echo "6) Executar todas as operações de atualização e limpeza"
    echo "0) Sair"
    
    read -p "Opção: " opcao
    
    case $opcao in
        1) atualizar_lista_pacotes ;;
        2) atualizar_pacotes ;;
        3) atualizar_distribuicao ;;
        4) corrigir_erros ;;
        5) limpar_sistema ;;
        6) atualizar_completo ;;
        0) echo "Saindo..."; exit ;;
        *) echo "Opção inválida! Tente novamente." ;;
    esac
done
