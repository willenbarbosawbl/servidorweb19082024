#!/bin/bash

# Função para instalar o phpMyAdmin
install_phpmyadmin() {
    echo "Atualizando pacotes..."
    sudo apt update
    
    echo "Instalando phpMyAdmin..."
    sudo apt install phpmyadmin -y
    
    echo "Configurando phpMyAdmin com o Apache2..."
    sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
    
    echo "phpMyAdmin instalado com sucesso!"
}

# Função para desinstalar o phpMyAdmin
uninstall_phpmyadmin() {
    echo "Desinstalando phpMyAdmin..."
    sudo apt remove phpmyadmin -y
    sudo apt purge phpmyadmin -y
    
    echo "phpMyAdmin foi desinstalado."
    
    read -p "Deseja apagar a pasta do phpMyAdmin (/usr/share/phpmyadmin)? (s/N): " delete_folder
    if [[ "$delete_folder" =~ ^[Ss]$ ]]; then
        sudo rm -rf /usr/share/phpmyadmin
        sudo rm -rf /var/www/html/phpmyadmin
        echo "Pasta do phpMyAdmin apagada."
    else
        echo "A pasta do phpMyAdmin não foi apagada."
    fi
}

# Menu de opções
while true; do
    echo "Escolha uma opção:"
    echo "1. Instalar phpMyAdmin"
    echo "2. Desinstalar phpMyAdmin"
    echo "0. Sair"
    read -p "Opção: " option

    case $option in
        1)
            install_phpmyadmin
            ;;
        2)
            uninstall_phpmyadmin
            ;;
        0)
            echo "Saindo..."
            break
            ;;
        *)
            echo "Opção inválida, por favor escolha 1, 2 ou 0."
            ;;
    esac
done
