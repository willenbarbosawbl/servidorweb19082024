#!/bin/bash

# Lista de TLDs internacionais e brasileiros
TLDs_BRASIL=(
    "br" "com.br" "net.br" "org.br" "gov.br" "edu.br" "mil.br" "art.br" "blog.br" "eco.br" "emp.br" "ind.br" "inf.br" "med.br" "rec.br" "srv.br" "tur.br" "adv.br" "agr.br" "am.br" "b.br" "cim.br" "cng.br" "cnt.br" "coop.br" "eng.br" "esp.br" "etc.br" "eti.br" "far.br" "fnd.br" "fot.br" "fst.br" "ggf.br" "imb.br" "jor.br" "lel.br" "mat.br" "mus.br" "not.br" "odo.br" "ppg.br" "psc.br" "psi.br" "qsl.br" "slg.br" "tmp.br" "trd.br" "vet.br"
)

TLDs_INTERNACIONAIS=(
    "com" "org" "net" "info" "biz" "edu" "gov" "int" "mil" "asia" "eu" "tel" "mobi" "name" "pro" "aero" "coop" "museum" "cat" "jobs" "travel" "xxx" "post" "sco" "audio" "auto" "app" "art" "bank" "bar" "cafe" "dev" "eco" "film" "gal" "hotel" "kids" "law" "med" "music" "news" "radio" "shop" "store" "tech" "web" "zone"
)

# Função para remover acentos e espaços
remove_acentos_espacos() {
    echo "$1" | iconv -f utf8 -t ascii//TRANSLIT | tr -d ' '
}

# Função para verificar se o TLD é válido
tld_valido() {
    local dominio="$1"
    local tld="${dominio##*.}"

    # Verifica nos TLDs internacionais
    for valid_tld in "${TLDs_INTERNACIONAIS[@]}"; do
        if [ "$tld" == "$valid_tld" ]; then
            return 0
        fi
    done

    # Verifica nos TLDs do Brasil
    for valid_tld in "${TLDs_BRASIL[@]}"; do
        if [ "$tld" == "$valid_tld" ]; then
            return 0
        fi
    done

    return 1
}

# Função para remover a extensão do domínio
remover_extensao_dominio() {
    local dominio="$1"
    local usuario="${dominio%%.*}"
    echo "$usuario"
}

# Função que cria cabeçalho HTML
create_html_header(){
    echo '<!DOCTYPE html>' >> "$1"
    echo '<html lang="pt-br">' >> "$1"
    echo '<head>' >> "$1"
    echo '    <meta charset="UTF-8">' >> "$1"
    echo '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' >> "$1"
    echo "    <title>$2</title>" >> "$1"
    echo '    <link href="https://stackpath.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">' >> "$1"
    echo '    <style>' >> "$1"
    echo '        body, html {' >> "$1"
    echo '            height: 100%;' >> "$1"
    echo '            margin: 0;' >> "$1"
    echo '            font-family: Arial, Helvetica, sans-serif;' >> "$1"
    echo '        }' >> "$1"
    echo '        .bg {' >> "$1"
    echo '            background-image: url('"'"'https://img.freepik.com/free-photo/zen-stones-sand-background-health-wellness-concept_53876-124303.jpg?t=st=1716698385~exp=1716701985~hmac=ead285b8abd7ce059b0965eb63452f48d2308bebf957990f545328d80b496541&w=2000'"'"');' >> "$1"
    echo '            height: 100%;' >> "$1"
    echo '            background-position: center;' >> "$1"
    echo '            background-repeat: no-repeat;' >> "$1"
    echo '            background-size: cover;' >> "$1"
    echo '        }' >> "$1"
    echo '        .centered-message {' >> "$1"
    echo '            position: absolute;' >> "$1"
    echo '            top: 50%;' >> "$1"
    echo '            left: 50%;' >> "$1"
    echo '            transform: translate(-50%, -50%);' >> "$1"
    echo '            color: white;' >> "$1"
    echo '            text-align: center;' >> "$1"
    echo '            padding: 20px;' >> "$1"
    echo '            background: rgba(0, 0, 0, 0.6);' >> "$1"
    echo '            border-radius: 10px;' >> "$1"
    echo '        }' >> "$1"
    echo '    </style>' >> "$1"
    echo '</head>' >> "$1"
    echo '<body>' >> "$1"
}

# Função que cria rodapé HTML
create_html_footer(){
    echo '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>' >> "$1"
    echo '</body>' >> "$1"
    echo '</html>' >> "$1"
}

# Função que cria página de erro 404
create_page_404(){
    echo "Criando página 404 padrão..."
    USER_HOME=$1
    PAGE_ERROR_DIR="$USER_HOME/page_error"
    PATH_ERROR="$PAGE_ERROR_DIR/404.html"
    TITLE="404 Página não encontrada."

    # Criar cabeçalho HTML
    create_html_header "$PATH_ERROR" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_ERROR"
    echo '        <div class="centered-message">' >> "$PATH_ERROR"
    echo "            <h1>$TITLE</h1>" >> "$PATH_ERROR"
    echo '            <p>A página que você está procurando não foi encontrada.</p>' >> "$PATH_ERROR"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_ERROR"
    echo '        </div>' >> "$PATH_ERROR"
    echo '    </div>' >> "$PATH_ERROR"
    # Criar rodapé HTML
    create_html_footer "$PATH_ERROR"
    echo "Página 404 criada em $PATH_ERROR"
}

# Função que cria página de erro 405
create_page_405(){
    echo "Criando página 405 padrão..."
    USER_HOME=$1
    PAGE_ERROR_DIR="$USER_HOME/page_error"
    PATH_ERROR="$PAGE_ERROR_DIR/405.html"
    TITLE="405 Método não permitido."

    # Criar cabeçalho HTML
    create_html_header "$PATH_ERROR" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_ERROR"
    echo '        <div class="centered-message">' >> "$PATH_ERROR"
    echo "            <h1>$TITLE</h1>" >> "$PATH_ERROR"
    echo '            <p>O método HTTP que você usou para acessar esta página não é permitido.</p>' >> "$PATH_ERROR"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_ERROR"
    echo '        </div>' >> "$PATH_ERROR"
    echo '    </div>' >> "$PATH_ERROR"
    # Criar rodapé HTML
    create_html_footer "$PATH_ERROR"
    echo "Página 405 criada em $PATH_ERROR"
}

# Função que cria página de erro 500
create_page_500(){
    echo "Criando página 500 padrão..."
    USER_HOME=$1
    PAGE_ERROR_DIR="$USER_HOME/page_error"
    PATH_ERROR="$PAGE_ERROR_DIR/500.html"
    TITLE="500 Erro interno do servidor"

    # Criar cabeçalho HTML
    create_html_header "$PATH_ERROR" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_ERROR"
    echo '        <div class="centered-message">' >> "$PATH_ERROR"
    echo "            <h1>$TITLE</h1>" >> "$PATH_ERROR"
    echo '            <p>Ocorreu um erro interno no servidor. Por favor, tente novamente mais tarde.</p>' >> "$PATH_ERROR"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_ERROR"
    echo '        </div>' >> "$PATH_ERROR"
    echo '    </div>' >> "$PATH_ERROR"
    # Criar rodapé HTML
    create_html_footer "$PATH_ERROR"
    echo "Página 500 criada em $PATH_ERROR"
}

# Função que cria o arquivo index.php
create_index_php(){
    echo "Criando arquivo index.php..."
    USER_HOME=$1
    INDEX_FILE="$USER_HOME/public_html/index.php"

    echo '<?php' > "$INDEX_FILE"
    echo 'phpinfo();' >> "$INDEX_FILE"
    echo '?>' >> "$INDEX_FILE"
    echo "Arquivo index.php criado em $INDEX_FILE"
}

# Função que cria o arquivo info.php
create_info_php(){
    echo "Criando arquivo info.php..."
    USER_HOME=$1
    INFO_FILE="$USER_HOME/public_html/info.php"

    echo '<?php' > "$INFO_FILE"
    echo 'phpinfo();' >> "$INFO_FILE"
    echo '?>' >> "$INFO_FILE"
    echo "Arquivo info.php criado em $INFO_FILE"
}

# Função para criar um certificado SSL autoassinado
create_ssl_certificate() {
    echo "Criando certificado SSL autoassinado..."
    USER_HOME=$1
    DOMAIN=$2
    SSL_DIR="$USER_HOME/ssl"
    CERT_FILE="$SSL_DIR/$DOMAIN.crt"
    KEY_FILE="$SSL_DIR/$DOMAIN.key"

    mkdir -p "$SSL_DIR"

    openssl req -newkey rsa:2048 -nodes -keyout "$KEY_FILE" -x509 -days 365 -out "$CERT_FILE" \
        -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=Colegio Sao Goncalo/OU=TI Colegio Sao Goncalo/CN=$DOMAIN"

    echo "Certificado SSL criado em $CERT_FILE e chave em $KEY_FILE"
}

# Função que cria um link simbólico para o phpMyAdmin
create_phpmyadmin_link(){
    echo "Criando link simbólico para o phpMyAdmin..."
    USER_HOME=$1
    PHP_MY_ADMIN_DIR="/usr/share/phpmyadmin"
    ln -s "$PHP_MY_ADMIN_DIR" "$USER_HOME/public_html/phpmyadmin"
    echo "Link simbólico para o phpMyAdmin criado em $USER_HOME/public_html/phpmyadmin"
}

# Função que configura o Nginx
configure_nginx(){
    echo "Configurando o Nginx..."
    USER_HOME=$1
    DOMAIN=$2
    NGINX_CONF="/etc/nginx/sites-available/$DOMAIN"
    NGINX_ENABLED_CONF="/etc/nginx/sites-enabled/$DOMAIN"
    PAGE_ERROR_DIR="$USER_HOME/page_error"
    LOGS_DIR="$USER_HOME/logs"
    SSL_DIR="$USER_HOME/ssl"

    # Criar configuração do Nginx
    echo "server {" > "$NGINX_CONF"
    echo "    listen 80;" >> "$NGINX_CONF"
    echo "    listen [::]:80;" >> "$NGINX_CONF"
    echo "    server_name $DOMAIN;" >> "$NGINX_CONF"
    echo "    root $USER_HOME/public_html;" >> "$NGINX_CONF"
    echo "    index index.php index.html index.htm;" >> "$NGINX_CONF"
    echo "" >> "$NGINX_CONF"
    echo "    location / {" >> "$NGINX_CONF"
    echo "        try_files \$uri \$uri/ =404;" >> "$NGINX_CONF"
    echo "    }" >> "$NGINX_CONF"
    echo "" >> "$NGINX_CONF"
    echo "    location ~ \.php$ {" >> "$NGINX_CONF"
    echo "        include snippets/fastcgi-php.conf;" >> "$NGINX_CONF"
    echo "        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;" >> "$NGINX_CONF"
    echo "        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> "$NGINX_CONF"
    echo "        include fastcgi_params;" >> "$NGINX_CONF"
    echo "    }" >> "$NGINX_CONF"
    echo "" >> "$NGINX_CONF"
    echo "    error_log $LOGS_DIR/error.log;" >> "$NGINX_CONF"
    echo "    access_log $LOGS_DIR/access.log;" >> "$NGINX_CONF"
    echo "" >> "$NGINX_CONF"
    echo "    error_page 403 404 500 502 503 504 /404.html;" >> "$NGINX_CONF"
    echo "    location = /404.html {" >> "$NGINX_CONF"
    echo "        root $PAGE_ERROR_DIR;" >> "$NGINX_CONF"
    echo "    }" >> "$NGINX_CONF"
    echo "" >> "$NGINX_CONF"
    echo "    ssl_certificate $SSL_DIR/localhost.crt;" >> "$NGINX_CONF"
    echo "    ssl_certificate_key $SSL_DIR/localhost.key;" >> "$NGINX_CONF"
    echo "" >> "$NGINX_CONF"
    echo "}" >> "$NGINX_CONF"

    ln -s "$NGINX_CONF" "$NGINX_ENABLED_CONF"
    echo "Configuração do Nginx criada em $NGINX_CONF e ativada em $NGINX_ENABLED_CONF"
}

# Função para criar diretórios
create_directories(){
    USER_HOME=$1
    echo "Criando diretórios..."
    mkdir -p "$USER_HOME/public_html"
    mkdir -p "$USER_HOME/page_error"
    mkdir -p "$USER_HOME/logs"
    mkdir -p "$USER_HOME/ssl"
}

# Função para criar o usuário e adicionar ao grupo www-data
create_user(){
    USERNAME=$1
    echo "Criando usuário $USERNAME..."
    useradd -m -s /bin/bash "$USERNAME"
    usermod -aG www-data "$USERNAME"
}

# Função principal do script
main(){
    read -p "Digite o domínio (exemplo: exemplo.com): " DOMINIO

    # Verifica a validade do TLD
    if ! tld_valido "$DOMINIO"; then
        echo "TLD inválido. Por favor, insira um domínio válido."
        exit 1
    fi

    USUARIO=$(remover_extensao_dominio "$DOMINIO")
    USER_HOME="/home/$USUARIO"

    create_user "$USUARIO"
    create_directories "$USER_HOME"
    create_index_php "$USER_HOME"
    create_info_php "$USER_HOME"
    create_page_404 "$USER_HOME"
    create_page_405 "$USER_HOME"
    create_page_500 "$USER_HOME"
    create_ssl_certificate "$USER_HOME" "$DOMINIO"
    configure_nginx "$USER_HOME" "$DOMINIO"
    create_phpmyadmin_link "$USER_HOME"

    echo "Configuração concluída!"
}

main
