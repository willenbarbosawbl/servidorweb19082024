#!/bin/bash

# Função para instalar SSL e criar certificado autoassinado
install_ssl() {
    echo "Instalando OpenSSL..."
    sudo apt-get update
    sudo apt-get install openssl -y

    echo "Criando diretório para armazenar o certificado SSL..."
    SSL_DIR="/etc/ssl/apache"
    sudo mkdir -p "$SSL_DIR"

    echo "Criando certificado SSL autoassinado..."
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$SSL_DIR/localhost.key" \
        -out "$SSL_DIR/localhost.crt" \
        -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Colegio Sao Goncalo/OU=TI Colegio Sao Goncalo/CN=localhost"

    echo "Configurando o Apache para usar SSL..."
    sudo a2enmod ssl
    sudo a2ensite default-ssl.conf

    echo "Atualizando o arquivo de configuração padrão do Apache para usar o certificado SSL..."
    sudo sed -i "s|SSLCertificateFile.*|SSLCertificateFile $SSL_DIR/localhost.crt|" /etc/apache2/sites-available/default-ssl.conf
    sudo sed -i "s|SSLCertificateKeyFile.*|SSLCertificateKeyFile $SSL_DIR/localhost.key|" /etc/apache2/sites-available/default-ssl.conf

    echo "Reiniciando o Apache..."
    sudo systemctl restart apache2

    echo "SSL instalado e configurado com sucesso."
}

# Função para desinstalar SSL e apagar a pasta
uninstall_ssl() {
    echo "Desinstalando SSL..."
    sudo a2dismod ssl
    sudo a2dissite default-ssl.conf
    sudo systemctl restart apache2
    sudo apt-get remove --purge openssl -y

    # Perguntar se deseja apagar a pasta SSL
    read -rp "Deseja apagar a pasta SSL ($SSL_DIR)? (s/n): " apagar_pasta
    if [ "$apagar_pasta" = "s" ]; then
        sudo rm -rf "$SSL_DIR"
        echo "Pasta SSL apagada."
    fi

    echo "SSL desinstalado e sistema limpo."
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
    echo "1) Instalar SSL e criar certificado"
    echo "2) Desinstalar SSL"
    echo "0) Sair"
    read -rp "Opção: " opcao

    case $opcao in
        1)
            install_ssl
            clean_system
            ;;
        2)
            uninstall_ssl
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
