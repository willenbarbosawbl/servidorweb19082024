#!/bin/bash

# Função para instalar PHP 8.3, módulos necessários e configurar Apache2
install_php() {
    echo "Instalando PHP 8.3 e módulos..."
    apt update
    apt install -y php8.3 php8.3-fpm php8.3-mysql php8.3-imap php8.3-ldap php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip libapache2-mod-php8.3
    echo "PHP 8.3 e módulos instalados com sucesso."

    echo "Configurando PHP 8.3 para produção..."
    sed -i 's/^;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.3/fpm/php.ini
    sed -i 's/^display_errors = On/display_errors = Off/' /etc/php/8.3/fpm/php.ini
    sed -i 's/^expose_php = On/expose_php = Off/' /etc/php/8.3/fpm/php.ini
    sed -i 's/^;session.cookie_secure =/session.cookie_secure =/' /etc/php/8.3/fpm/php.ini
    sed -i 's/^;opcache.enable=0/opcache.enable=1/' /etc/php/8.3/fpm/php.ini
    echo "Configuração de produção aplicada ao PHP 8.3."

    echo "Configurando o Apache2 para suportar arquivos PHP..."
    a2enmod php8.3
    a2enmod proxy_fcgi setenvif
    a2enconf php8.3-fpm
    echo "<FilesMatch \.php$>
    SetHandler \"proxy:unix:/run/php/php8.3-fpm.sock|fcgi://localhost/\"
</FilesMatch>" > /etc/apache2/conf-available/php8.3-fpm.conf
    a2enconf php8.3-fpm
    systemctl restart apache2
    echo "Apache2 configurado para suportar arquivos PHP."

    echo "Habilitando mod rewrite no Apache2..."
    a2enmod rewrite
    systemctl restart apache2
    echo "mod_rewrite habilitado no Apache2."

    echo "Criando a página info.php..."
    echo "<?php phpinfo(); ?>" > /var/www/html/info.php
    chown www-data:www-data /var/www/html/info.php
    chmod 644 /var/www/html/info.php
    echo "Página info.php criada em /var/www/html/info.php."
}

# Função para remover PHP 8.3 e módulos
remove_php() {
    echo "Removendo PHP 8.3 e módulos..."
    apt purge -y php8.3 php8.3-fpm php8.3-mysql php8.3-imap php8.3-ldap php8.3-xml php8.3-curl php8.3-mbstring php8.3-zip libapache2-mod-php8.3
    apt autoremove -y
    echo "PHP 8.3 e módulos removidos com sucesso."

    read -p "Deseja apagar a pasta de configuração do PHP? (s/n): " choice
    if [[ "$choice" == "s" || "$choice" == "S" ]]; then
        rm -rf /etc/php/8.3
        echo "Pasta de configuração do PHP apagada."
    fi

    echo "Removendo a página info.php..."
    rm -f /var/www/html/info.php
    echo "Página info.php removida."
}

# Menu principal
while true; do
    echo "1. Instalar PHP 8.3"
    echo "2. Configurar PHP 8.3 para produção"
    echo "3. Remover PHP 8.3"
    echo "0. Sair"
    read -p "Escolha uma opção: " option

    case $option in
        1) install_php ;;
        2) echo "Configurações já aplicadas durante a instalação." ;;
        3) remove_php ;;
        0) echo "Saindo..."; exit 0 ;;
        *) echo "Opção inválida. Tente novamente." ;;
    esac
done
