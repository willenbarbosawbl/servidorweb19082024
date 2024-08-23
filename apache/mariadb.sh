#!/bin/bash

# Função para instalar o MariaDB
install_mariadb() {
    echo "Instalando MariaDB..."
    sudo apt-get update
    sudo apt-get install mariadb-server -y
    sudo systemctl enable mariadb
    sudo systemctl start mariadb

    echo "Configurando MariaDB com 'mysql_secure_installation'..."
    sudo mysql_secure_installation

    echo "MariaDB instalado e configurado com sucesso."
}

# Função para desinstalar o MariaDB
uninstall_mariadb() {
    echo "Desinstalando MariaDB..."
    sudo systemctl stop mariadb
    sudo apt-get remove --purge mariadb-server mariadb-client mariadb-common mariadb-server-core mariadb-client-core -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean

    # Perguntar se deseja apagar a pasta do MariaDB
    read -rp "Deseja apagar a pasta do MariaDB (/var/lib/mysql)? (s/n): " apagar_pasta
    if [ "$apagar_pasta" = "s" ]; then
        sudo rm -rf /var/lib/mysql
        echo "Pasta do MariaDB apagada."
    fi

    echo "MariaDB desinstalado e sistema limpo."
}

# Função para limpar o sistema após instalação ou desinstalação
clean_system() {
    echo "Limpando o sistema..."
    sudo apt-get autoremove -y
    sudo apt-get autoclean
    echo "Sistema limpo."
}

# Menu de opções
while true; do
    echo "Escolha uma opção:"
    echo "1) Instalar MariaDB"
    echo "2) Desinstalar MariaDB"
    echo "0) Sair"
    read -rp "Opção: " opcao

    case $opcao in
        1)
            install_mariadb
            clean_system
            ;;
        2)
            uninstall_mariadb
            clean_system
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done
