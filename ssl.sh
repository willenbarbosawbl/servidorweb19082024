#!/bin/bash

# Diretório onde os certificados SSL serão armazenados
SSL_DIR="/etc/nginx/ssl"
# Caminho do arquivo de configuração padrão do Nginx
NGINX_DEFAULT_CONF="/etc/nginx/sites-available/default"

install_ssl() {
    echo "Instalando pacotes necessários para SSL..."
    sudo apt-get update
    sudo apt-get install -y openssl
    echo "Pacotes instalados com sucesso."
}

configure_ssl() {
    # Solicitar o nome do domínio ao usuário
    read -p "Digite o nome do domínio (ex: meudominio.com): " DOMAIN_NAME
    
    # Criar diretório para armazenar certificados SSL
    echo "Criando diretório para armazenar certificados SSL em ${SSL_DIR}..."
    sudo mkdir -p "${SSL_DIR}"

    # Gerar certificado autoassinado para o domínio fornecido
    echo "Gerando certificado autoassinado para ${DOMAIN_NAME}..."
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "${SSL_DIR}/${DOMAIN_NAME}.key" \
        -out "${SSL_DIR}/${DOMAIN_NAME}.crt" \
        -subj "/CN=${DOMAIN_NAME}/O=MyCompany/C=BR"

    # Configurar Nginx para usar o certificado SSL de acordo com o modelo fornecido
    echo "Configurando Nginx para usar o certificado SSL..."
    sudo bash -c "cat > ${NGINX_DEFAULT_CONF}" <<EOL
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        listen 443 ssl;
        listen [::]:443 ssl;

        ssl_certificate ${SSL_DIR}/${DOMAIN_NAME}.crt;
        ssl_certificate_key ${SSL_DIR}/${DOMAIN_NAME}.key;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name default_server;

        location / {
                try_files \$uri \$uri/ =404;
        }

	location ~ \.php$ {
        	include snippets/fastcgi-php.conf;
	        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
	        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	        include fastcgi_params;
   	}

	location ~ /\.ht {
		deny all;
	}
}
EOL

    echo "Reiniciando o Nginx..."
    sudo systemctl restart nginx

    echo "Configuração do SSL para ${DOMAIN_NAME} concluída com sucesso."
}

uninstall_ssl() {
    echo "Removendo configurações SSL do arquivo de configuração do Nginx..."
    sudo sed -i "/listen 443 ssl;/d" "${NGINX_DEFAULT_CONF}"
    sudo sed -i "/ssl_certificate /d" "${NGINX_DEFAULT_CONF}"
    sudo sed -i "/ssl_certificate_key /d" "${NGINX_DEFAULT_CONF}"

    echo "Reiniciando o Nginx..."
    sudo systemctl restart nginx

    echo "Deseja remover os arquivos de certificados SSL em ${SSL_DIR}? (s/n)"
    read -r REMOVE_SSL

    if [[ "$REMOVE_SSL" == "s" || "$REMOVE_SSL" == "S" ]]; then
        echo "Removendo diretório ${SSL_DIR}..."
        sudo rm -rf "${SSL_DIR}"
        echo "Certificados SSL removidos."
    else
        echo "Certificados SSL mantidos."
    fi

    echo "Desinstalação do SSL concluída."
}

# Menu principal
while true; do
    echo "Escolha uma opção:"
    echo "1) Instalar SSL"
    echo "2) Configurar SSL"
    echo "3) Desinstalar SSL"
    echo "0) Sair"
    read -r OPTION

    case $OPTION in
        1)
            install_ssl
            ;;
        2)
            configure_ssl
            ;;
        3)
            uninstall_ssl
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida."
            ;;
    esac
done
