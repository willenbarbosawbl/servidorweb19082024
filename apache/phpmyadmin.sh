#!/bin/bash

# Função para instalar phpMyAdmin
install_phpmyadmin() {
    echo "Instalando phpMyAdmin..."
    sudo apt-get update
    sudo apt-get install phpmyadmin -y

    echo "Configurando phpMyAdmin..."
    sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin

    echo "phpMyAdmin instalado e configurado com sucesso."
}

# Função para desinstalar phpMyAdmin
uninstall_phpmyadmin() {
    echo "Desinstalando phpMyAdmin..."
    sudo apt-get remove --purge phpmyadmin -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean

    # Perguntar se deseja apagar a pasta phpMyAdmin
    read -rp "Deseja apagar a pasta phpMyAdmin (/usr/share/phpmyadmin)? (s/n): " apagar_pasta
    if [ "$apagar_pasta" = "s" ]; then
        sudo rm -rf /usr/share/phpmyadmin
        echo "Pasta phpMyAdmin apagada."
    fi

    echo "phpMyAdmin desinstalado e sistema limpo."
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
    echo "1) Instalar phpMyAdmin"
    echo "2) Desinstalar phpMyAdmin"
    echo "0) Sair"
    read -rp "Opção: " opcao

    case $opcao in
        1)
            install_phpmyadmin
            clean_system
            ;;
        2)
            uninstall_phpmyadmin
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
