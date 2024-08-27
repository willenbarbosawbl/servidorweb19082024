#!/bin/bash

PHP_INI="/etc/php/$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')/apache2/php.ini"
PHP_FOLDER="/etc/php/"

# Função para ajustar o PHP para ambiente de produção
configure_php_for_production() {
    echo "Configurando PHP para ambiente de produção..."

    # Realizando alterações no php.ini
    sed -i "s/^expose_php = On/expose_php = Off/" $PHP_INI
    sed -i "s/^display_errors = On/display_errors = Off/" $PHP_INI
    sed -i "s/^display_startup_errors = On/display_startup_errors = Off/" $PHP_INI
    sed -i "s/^track_errors = On/track_errors = Off/" $PHP_INI
    sed -i "s/^log_errors = Off/log_errors = On/" $PHP_INI
    sed -i "s/^error_log = .*/error_log = \/var\/log\/php_errors.log/" $PHP_INI
    sed -i "s/^session.use_strict_mode = 0/session.use_strict_mode = 1/" $PHP_INI
    sed -i "s/^session.cookie_httponly =/session.cookie_httponly = 1/" $PHP_INI
    sed -i "s/^session.cookie_secure =/session.cookie_secure = 1/" $PHP_INI
    sed -i "s/^session.use_only_cookies = 0/session.use_only_cookies = 1/" $PHP_INI
    sed -i "s/^memory_limit = .*/memory_limit = 128M/" $PHP_INI
    sed -i "s/^max_execution_time = .*/max_execution_time = 30/" $PHP_INI
    sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 10M/" $PHP_INI
    sed -i "s/^post_max_size = .*/post_max_size = 10M/" $PHP_INI

    # Outras medidas de segurança
    echo "Verificando e aplicando outras medidas de segurança..."

    # Criar diretório seguro para logs PHP
    if [ ! -d "/var/log/php" ]; then
        mkdir /var/log/php
        chown www-data:www-data /var/log/php
    fi

    echo "Reiniciando o Apache2 para aplicar as configurações..."
    systemctl restart apache2

    echo "Configuração de produção aplicada com sucesso!"
}

# Função para instalar o PHP e módulos
install_php() {
    echo "Instalando PHP e módulos..."
    apt update
    apt install libapache2-mod-php php php-mysql php-cli php-pear php-gmp php-gd php-bcmath php-mbstring php-curl php-xml php-zip -y
    
    configure_php_for_production

    echo "Criando arquivo phpinfo.php..."
    echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
    echo "PHP instalado e configurado com sucesso!"
    php --version
}

# Função para desinstalar o PHP e módulos
uninstall_php() {
    echo "Desinstalando PHP e módulos..."
    apt remove --purge libapache2-mod-php php php-mysql php-cli php-pear php-gmp php-gd php-bcmath php-mbstring php-curl php-xml php-zip -y
    apt autoremove -y
    echo "PHP desinstalado com sucesso!"
    
    # Apagar a pasta de configuração do PHP e o arquivo phpinfo.php
    read -p "Deseja apagar a pasta do PHP (/etc/php/) e o arquivo /var/www/html/phpinfo.php? (s/n): " delete_php_folder
    if [[ $delete_php_folder == "s" || $delete_php_folder == "S" ]]; then
        rm -rf $PHP_FOLDER
        rm -f /var/www/html/phpinfo.php
        echo "Pasta do PHP e arquivo phpinfo.php removidos."
    else
        echo "Pasta do PHP e arquivo phpinfo.php mantidos."
    fi
}

# Menu de opções
echo "Escolha uma opção:"
echo "1) Instalar PHP"
echo "2) Desinstalar PHP"
echo "0) Sair"
read -p "Opção: " option

case $option in
    1)
        install_php
        ;;
    2)
        uninstall_php
        ;;
    0)
        echo "Saindo..."
        exit 0
        ;;
    *)
        echo "Opção inválida!"
        ;;
esac
