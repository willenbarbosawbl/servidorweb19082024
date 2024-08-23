#!/bin/bash

# Função para instalar o Nginx
install_nginx() {
    echo "Instalando o Nginx..."
    sudo apt update
    sudo apt install nginx -y

    echo "Nginx instalado com sucesso."
}

# Função para desinstalar o Nginx
uninstall_nginx() {
    echo "Desinstalando o Nginx..."
    sudo systemctl stop nginx
    sudo apt remove nginx nginx-common -y
    sudo apt purge nginx nginx-common -y
    sudo apt autoremove -y

    echo "Nginx desinstalado com sucesso."
}

# Função para remover a pasta do Nginx
remove_nginx_folder() {
    echo "Informe o caminho da pasta do Nginx que deseja remover:"
    read nginx_folder_path

    if [ -d "$nginx_folder_path" ]; then
        sudo rm -rf "$nginx_folder_path"
        echo "Pasta $nginx_folder_path removida com sucesso."
    else
        echo "A pasta $nginx_folder_path não existe."
    fi
}

# Menu principal
while true; do
    echo "Escolha uma opção:"
    echo "1) Instalar Nginx"
    echo "2) Desinstalar Nginx"
    echo "3) Remover pasta do Nginx"
    echo "0) Sair"
    read -p "Opção: " option

    case $option in
        1)
            install_nginx
            ;;
        2)
            uninstall_nginx
            ;;
        3)
            remove_nginx_folder
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
