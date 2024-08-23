#!/bin/bash

# Função para instalar o Apache e habilitar o mod_rewrite
install_apache() {
    echo "Instalando o Apache..."
    sudo apt-get update
    sudo apt-get install apache2 -y
    sudo systemctl enable apache2
    sudo systemctl start apache2

    echo "Habilitando o mod_rewrite..."
    sudo a2enmod rewrite
    sudo systemctl restart apache2

    echo "Apache instalado e configurado com sucesso, mod_rewrite habilitado."
}

# Função para desinstalar o Apache
uninstall_apache() {
    echo "Desinstalando o Apache..."
    sudo systemctl stop apache2
    sudo apt-get remove --purge apache2 -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean
    echo "Apache desinstalado e sistema limpo."
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
    echo "1) Instalar Apache"
    echo "2) Desinstalar Apache"
    echo "0) Sair"
    read -rp "Opção: " opcao

    case $opcao in
        1)
            install_apache
            clean_system
            ;;
        2)
            uninstall_apache
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
