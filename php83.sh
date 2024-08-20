#!/bin/bash

USER_DIR=""

# Função para instalar o PHP 8.3 e extensões necessárias
install_php() {
    sudo apt update
    sudo apt install -y php8.3 php8.3-fpm php8.3-mysql php8.3-imap php8.3-ldap php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip

    read -p "Informe o nome do usuário para configurar as pastas: " USER_DIR
    PUBLIC_HTML="/home/$USER_DIR/public_html"

    # Criar pasta public_html se não existir
    sudo mkdir -p $PUBLIC_HTML

    # Criar arquivos info.php e index.php
    echo "<?php phpinfo(); ?>" | sudo tee $PUBLIC_HTML/info.php > /dev/null
    echo "<h1>Bem-vindo ao PHP 8.3</h1>" | sudo tee $PUBLIC_HTML/index.php > /dev/null

    echo "PHP 8.3 instalado e arquivos info.php e index.php criados em $PUBLIC_HTML."
}

# Função para configurar PHP 8.3 para produção e para Nginx
configure_php_nginx() {
    PHP_INI_FILE="/etc/php/8.3/fpm/php.ini"
    NGINX_CONF_FILE="/etc/nginx/sites-available/default"

    # Configurações para produção no php.ini
    sudo sed -i "s/^display_errors = .*/display_errors = Off/" "$PHP_INI_FILE"
    sudo sed -i "s/^log_errors = .*/log_errors = On/" "$PHP_INI_FILE"
    sudo sed -i "s/^error_reporting = .*/error_reporting = E_ALL \& ~E_DEPRECATED \& ~E_STRICT/" "$PHP_INI_FILE"
    sudo sed -i "s/^cgi.fix_pathinfo = .*/cgi.fix_pathinfo = 0/" "$PHP_INI_FILE"
    sudo sed -i "s/^expose_php = .*/expose_php = Off/" "$PHP_INI_FILE"
    sudo sed -i "s/^;date.timezone =.*/date.timezone = UTC/" "$PHP_INI_FILE"
    sudo sed -i "s/^memory_limit = .*/memory_limit = 128M/" "$PHP_INI_FILE"
    sudo sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 10M/" "$PHP_INI_FILE"
    sudo sed -i "s/^post_max_size = .*/post_max_size = 10M/" "$PHP_INI_FILE"
    sudo sed -i "s/^max_execution_time = .*/max_execution_time = 30/" "$PHP_INI_FILE"
    sudo sed -i "s/^max_input_time = .*/max_input_time = 60/" "$PHP_INI_FILE"
    sudo sed -i "s/^session.cookie_httponly = .*/session.cookie_httponly = 1/" "$PHP_INI_FILE"
    sudo sed -i "s/^session.cookie_secure = .*/session.cookie_secure = 1/" "$PHP_INI_FILE"
    sudo sed -i "s/^disable_functions = .*/disable_functions = exec,passthru,shell_exec,system,proc_open,popen,curl_exec,curl_multi_exec,parse_ini_file,show_source/" "$PHP_INI_FILE"
    sudo sed -i "s/^allow_url_fopen = .*/allow_url_fopen = Off/" "$PHP_INI_FILE"
    sudo sed -i "s/^allow_url_include = .*/allow_url_include = Off/" "$PHP_INI_FILE"

    # Configuração do Nginx para usar PHP-FPM
    sudo sed -i "s|#location ~ \\.php$ {|location ~ \\.php$ {|" "$NGINX_CONF_FILE"
    sudo sed -i "s|#\tinclude snippets/fastcgi-php.conf;|\tinclude snippets/fastcgi-php.conf;|" "$NGINX_CONF_FILE"
    sudo sed -i "s|#\tfastcgi_pass unix:/var/run/php/php7.4-fpm.sock;|\tfastcgi_pass unix:/var/run/php/php8.3-fpm.sock;|" "$NGINX_CONF_FILE"
    sudo sed -i "s|#}|}|" "$NGINX_CONF_FILE"

    sudo systemctl restart php8.3-fpm
    sudo systemctl restart nginx

    echo "PHP 8.3 configurado para produção e para Nginx."
}

# Função para desinstalar o PHP 8.3 e extensões
uninstall_php() {
    sudo apt remove -y php8.3 php8.3-fpm php8.3-mysql php8.3-imap php8.3-ldap php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip
    sudo apt autoremove -y

    read -p "Deseja apagar a pasta PHP 8.3 (y/n)? " REMOVE_DIR
    if [[ "$REMOVE_DIR" == "y" ]]; then
        sudo rm -rf /etc/php/8.3
        echo "Pasta PHP 8.3 removida."
    fi

    echo "PHP 8.3 e extensões desinstaladas com sucesso."
}

echo "Escolha uma opção:"
echo "1 - Instalar PHP 8.3"
echo "2 - Configurar PHP 8.3 para produção e Nginx"
echo "3 - Desinstalar PHP 8.3"
echo "0 - Sair"
read -p "Opção: " OPTION

case $OPTION in
    1)
        install_php
        ;;
    2)
        configure_php_nginx
        ;;
    3)
        uninstall_php
        ;;
    0)
        echo "Saindo..."
        ;;
    *)
        echo "Opção inválida."
        ;;
esac
