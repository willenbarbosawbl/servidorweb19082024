#!/bin/bash

# Função para instalar o Apache2
install_apache2() {
    echo "Instalando Apache2..."
    apt update
    apt install apache2 apache2-utils -y

    echo "Habilitando módulos rewrite e headers..."
    a2enmod rewrite
    a2enmod headers

    echo "Configurando o arquivo padrão do Apache2..."
    cat <<EOL >> /etc/apache2/sites-available/000-default.conf
# Configurações de segurança
Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains"

# Configurações do diretório
<Directory /var/www/html/>
    Options FollowSymLinks
    AllowOverride All
</Directory>
EOL

    echo "Aplicando configurações de segurança adicionais..."
    sed -i 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/conf-available/security.conf
    sed -i 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf

    echo "Reiniciando o Apache2..."
    systemctl restart apache2

    echo "Apache2 instalado e configurado com sucesso."
}

# Função para desinstalar o Apache2
uninstall_apache2() {
    echo "Desinstalando Apache2..."
    apt remove --purge apache2 apache2-utils -y
    apt autoremove -y
    apt autoclean

    read -p "Deseja apagar a pasta /var/www/html? (s/n): " choice
    if [[ "$choice" == "s" || "$choice" == "S" ]]; then
        rm -rf /var/www/html
        echo "Pasta /var/www/html removida."
    fi

    echo "Apache2 desinstalado com sucesso."
}

# Menu principal
while true; do
    echo "Escolha uma opção:"
    echo "1) Instalar Apache2"
    echo "2) Desinstalar Apache2"
    echo "0) Sair"
    read -p "Opção: " option

    case $option in
        1)
            install_apache2
            ;;
        2)
            uninstall_apache2
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida! Tente novamente."
            ;;
    esac
done
