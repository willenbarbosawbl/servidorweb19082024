#!/bin/bash

# Função para instalar PHP 8.3, módulos e configurar PHP-FPM como principal
install_php() {
    echo "Instalando PHP 8.3 e módulos..."
    sudo apt-get update
    sudo apt-get install php8.3 php8.3-fpm php8.3-mysql php8.3-imap php8.3-ldap php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip -y

    echo "Configurando PHP 8.3 para produção..."
    sudo sed -i "s/^expose_php = .*/expose_php = Off/" /etc/php/8.3/fpm/php.ini
    sudo sed -i "s/^display_errors = .*/display_errors = Off/" /etc/php/8.3/fpm/php.ini
    sudo sed -i "s/^display_startup_errors = .*/display_startup_errors = Off/" /etc/php/8.3/fpm/php.ini
    sudo sed -i "s/^error_reporting = .*/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/" /etc/php/8.3/fpm/php.ini
    sudo sed -i "s/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.3/fpm/php.ini
    sudo sed -i "s/^session.cookie_secure = .*/session.cookie_secure = On/" /etc/php/8.3/fpm/php.ini
    sudo sed -i "s/^session.cookie_httponly = .*/session.cookie_httponly = On/" /etc/php/8.3/fpm/php.ini

    echo "Configurando Apache para usar PHP-FPM..."
    sudo a2enmod proxy_fcgi setenvif
    sudo a2enconf php8.3-fpm
    sudo systemctl restart apache2
    sudo systemctl restart php8.3-fpm

    echo "PHP 8.3 e PHP-FPM instalados e configurados com sucesso."
}

# Função para desinstalar PHP 8.3 e módulos
uninstall_php() {
    echo "Desinstalando PHP 8.3 e módulos..."
    sudo systemctl stop php8.3-fpm
    sudo apt-get remove --purge php8.3 php8.3-fpm php8.3-mysql php8.3-imap php8.3-ldap php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip -y
    sudo apt-get autoremove -y
    sudo apt-get autoclean
    echo "PHP 8.3 desinstalado e sistema limpo."
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
    echo "1) Instalar PHP 8.3"
    echo "2) Desinstalar PHP 8.3"
    echo "0) Sair"
    read -rp "Opção: " opcao

    case $opcao in
        1)
            install_php
            clean_system
            ;;
        2)
            uninstall_php
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
