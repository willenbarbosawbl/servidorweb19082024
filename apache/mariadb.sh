#!/bin/bash

# Função para instalar o MariaDB
install_mariadb() {
    echo "Instalando MariaDB..."
    sudo apt update
    sudo apt install -y mariadb-server mariadb-client

    if [ $? -eq 0 ]; then
        echo "MariaDB instalado com sucesso."
        configure_mariadb
    else
        echo "Falha na instalação do MariaDB."
        exit 1
    fi
}

# Função para configurar o MariaDB
configure_mariadb() {
    echo "Configurando MariaDB..."
    sudo mysql_secure_installation

    if [ $? -eq 0 ]; then
        echo "MariaDB configurado com sucesso."
    else
        echo "Falha na configuração do MariaDB."
        exit 1
    fi
}

# Função para desinstalar o MariaDB
uninstall_mariadb() {
    echo "Desinstalando MariaDB..."
    sudo apt remove --purge -y mariadb-server mariadb-client

    if [ $? -eq 0 ]; then
        echo "MariaDB desinstalado com sucesso."

        # Perguntar se o usuário deseja apagar a pasta do MariaDB
        read -p "Deseja apagar a pasta /var/lib/mysql? (s/n): " remove_folder
        if [ "$remove_folder" == "s" ]; then
            sudo rm -rf /var/lib/mysql
            echo "Pasta /var/lib/mysql removida."
        else
            echo "A pasta /var/lib/mysql não foi removida."
        fi

        sudo apt autoremove -y
        sudo apt clean
    else
        echo "Falha na desinstalação do MariaDB."
        exit 1
    fi
}

# Menu principal
while true; do
    echo "Escolha uma opção:"
    echo "1. Instalar MariaDB"
    echo "2. Configurar MariaDB"
    echo "3. Desinstalar MariaDB"
    echo "0. Sair"
    read -p "Opção: " option

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
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done
