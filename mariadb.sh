#!/bin/bash

# Função para instalar o MariaDB
install_mariadb() {
    echo "Instalando MariaDB..."
    sudo apt-get update
    sudo apt-get install -y mariadb-server
    echo "MariaDB instalado com sucesso."
}

# Função para configurar o MariaDB
configure_mariadb() {
    echo "Configurando MariaDB com mysql_secure_installation..."
    sudo mysql_secure_installation
    echo "MariaDB configurado com sucesso."
}

# Função para desinstalar o MariaDB
uninstall_mariadb() {
    echo "Desinstalando MariaDB..."
    sudo systemctl stop mariadb
    sudo apt-get purge -y mariadb-server mariadb-client mariadb-common mariadb-server-core-* mariadb-client-core-*
    sudo apt-get autoremove -y
    sudo apt-get autoclean

    # Perguntar se deseja apagar a pasta do MariaDB
    read -p "Deseja apagar a pasta do MariaDB (/var/lib/mysql)? (y/n): " remove_data
    if [ "$remove_data" == "y" ]; then
        echo "Apagando a pasta /var/lib/mysql..."
        sudo rm -rf /var/lib/mysql
        sudo rm -rf /etc/mysql
        echo "Pasta do MariaDB removida."
    else
        echo "Pasta do MariaDB mantida."
    fi

    echo "MariaDB desinstalado com sucesso."
}

# Função para exibir o menu
show_menu() {
    echo "1. Instalar MariaDB"
    echo "2. Configurar MariaDB"
    echo "3. Desinstalar MariaDB"
    echo "0. Sair"
    echo -n "Escolha uma opção: "
}

# Loop principal do menu
while true; do
    show_menu
    read option
    case $option in
        1)
            install_mariadb
            ;;
        2)
            configure_mariadb
            ;;
        3)
            uninstall_mariadb
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida!"
            ;;
    esac
done
