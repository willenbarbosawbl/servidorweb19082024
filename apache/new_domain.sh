#!/bin/bash

# Lista completa de domínios internacionais e do Brasil
DOMINIOS_VALIDOS=(
    # Domínios internacionais
    ".com" ".net" ".org" ".info" ".biz" ".edu" ".gov" ".mil" ".int"
    ".co" ".io" ".me" ".tv" ".cc" ".xyz" ".top" ".site" ".online" ".club" ".shop"
    ".store" ".tech" ".blog" ".art" ".app" ".dev" ".pro" ".name" ".mobi" ".asia"
    ".jobs" ".tel" ".travel" ".museum" ".aero" ".coop" ".cat" ".post" ".bio"
    ".tech" ".us" ".uk" ".eu" ".de" ".cn" ".jp" ".fr" ".es" ".ru" ".au" ".br"
    ".in" ".it" ".nl" ".se" ".no" ".ch" ".ca" ".mx" ".kr" ".tr" ".hk" ".pl"
    ".pt" ".be" ".at" ".dk" ".fi" ".cz" ".gr" ".il" ".ro" ".hu" ".sg" ".id"
    ".sa" ".ae" ".ir" ".th" ".my" ".ph" ".nz" ".za" ".pk" ".cl" ".ve" ".ar"
    ".uy" ".bo" ".py" ".pe" ".ec" ".gt" ".pa" ".do" ".cr" ".ni" ".hn" ".sv"
    ".bz" ".ai" ".ag" ".gd" ".ky" ".lc" ".ms" ".vc" ".vg" ".bm" ".bs" ".bb"
    ".kn" ".tc" ".mu" ".sc" ".dm" ".fm" ".ws" ".sb" ".nu" ".tk" ".cf" ".ga"
    ".ml" ".gq" ".rw" ".ug" ".tz" ".zm" ".mw" ".bw" ".ls" ".sz" ".na" ".ng"
    ".ke" ".gh" ".sd" ".et" ".dz" ".tn" ".ma" ".ly" ".ao" ".mz" ".cv" ".gw"
    ".st" ".cm" ".ci" ".bj" ".bf" ".ne" ".sn" ".gm" ".mr" ".ml" ".tn" ".er"
    ".dj" ".so" ".ug" ".rw" ".bi" ".sl" ".gm" ".tg" ".gm" ".sl" ".cv" ".ga"
    ".rw" ".tn" ".zm" ".ls" ".ao" ".bw" ".na" ".sz" ".er" ".so" ".dj" ".mr"
    ".ga" ".ci" ".bj" ".ne" ".sn" ".ke" ".gh" ".ng" ".et" ".sd" ".ug" ".rw"
    ".bi" ".ls" ".mw" ".mg" ".zw" ".mz" ".km" ".yt" ".sh" ".tf" ".io" ".gs"
    ".aq" ".pn" ".bv" ".sj" ".hm" ".tf" ".qa" ".bh" ".kw" ".om" ".ye" ".sy"
    ".lb" ".jo" ".ps" ".af" ".bd" ".bt" ".mv" ".np" ".lk" ".tj" ".tm" ".uz"
    ".kg" ".kz" ".mn" ".kh" ".la" ".vn" ".mm" ".np" ".tp" ".ws" ".sb" ".to"
    ".tv" ".vu" ".fk" ".pf" ".nc" ".tk" ".wf" ".ck" ".nu" ".cx" ".cc" ".as"
    ".cx" ".cc" ".gs" ".ki" ".nr" ".pw" ".ki" ".nr" ".ck" ".fm" ".ws" ".sb"
    ".nu" ".tk" ".wf" ".cx" ".cc" ".as" ".fm" ".mh" ".gu" ".mp" ".vi" ".ps"
    ".re" ".yt" ".tf" ".wf" ".ck" ".nu" ".to" ".vu"
    
    # Domínios do Brasil
    ".com.br" ".net.br" ".org.br" ".gov.br" ".edu.br" ".mil.br" ".adm.br" ".adv.br"
    ".agr.br" ".am.br" ".arq.br" ".art.br" ".ato.br" ".b.br" ".bio.br" ".blog.br"
    ".bmd.br" ".cim.br" ".cng.br" ".cnt.br" ".coop.br" ".ecn.br" ".eco.br" ".emp.br"
    ".eng.br" ".esp.br" ".etc.br" ".eti.br" ".far.br" ".flog.br" ".fm.br" ".fnd.br"
    ".fot.br" ".fst.br" ".g12.br" ".ggf.br" ".imb.br" ".ind.br" ".inf.br" ".jor.br"
    ".jus.br" ".lel.br" ".mat.br" ".med.br" ".mus.br" ".not.br" ".ntr.br" ".odo.br"
    ".ppg.br" ".pro.br" ".psc.br" ".psi.br" ".qsl.br" ".rec.br" ".slg.br" ".srv.br"
    ".taxi.br" ".teo.br" ".tmp.br" ".trd.br" ".tur.br" ".tv.br" ".vet.br" ".vlog.br"
    ".wiki.br" ".zlg.br"
)

# Função para remover acentos e espaços do nome do domínio
remove_acentos_espacos() {
    echo "$1" | iconv -f utf-8 -t ascii//TRANSLIT | sed 's/[^a-zA-Z0-9._-]//g'
}

# Função para verificar se a extensão do domínio é válida
validar_dominio() {
    local dominio="$1"
    for ext in "${DOMINIOS_VALIDOS[@]}"; do
        if [[ "$dominio" == *"$ext" ]]; then
            return 0
        fi
    done
    return 1
}

# Função para extrair o nome do usuário do domínio excluindo a extensão
extrair_nome_usuario() {
    local dominio="$1"
    for ext in "${DOMINIOS_VALIDOS[@]}"; do
        if [[ "$dominio" == *"$ext" ]]; then
            echo "${dominio%$ext}"
            return 0
        fi
    done
}

# Solicita o nome do domínio ao usuário
read -p "Digite o nome do domínio (ex: meudominio.com.br): " DOMINIO

# Limpa o nome do domínio removendo acentos e espaços
DOMINIO=$(remove_acentos_espacos "$DOMINIO")

# Verifica se o domínio é válido
while ! validar_dominio "$DOMINIO"; do
    echo "Domínio inválido. Por favor, insira um domínio com uma extensão válida."
    read -p "Digite o nome do domínio (ex: meudominio.com.br): " DOMINIO
    DOMINIO=$(remove_acentos_espacos "$DOMINIO")
    DOMINIO_COMPLETO="$DOMINIO"
done

# Função para criar o usuário e adicionar ao grupo www-data
cria_usuario(){
    local usuario="$1"
    # Cria o usuário com um diretório home, caso ainda não exista
    if ! id -u "$usuario" > /dev/null 2>&1; then
        sudo useradd -m -s /bin/bash "$usuario"
        echo "Usuário $usuario criado com sucesso."
    else
        echo "Usuário $usuario já existe."
    fi
    # Adiciona o usuário ao grupo www-data
    sudo usermod -aG www-data "$usuario"
    echo "Usuário $usuario adicionado ao grupo www-data."
}

# Função para criar as pastas necessárias e ajustar permissões
criar_pastas() {
    local usuario="$1"
    local home_dir="/home/$usuario"

    # Cria as pastas public_html, page_error, logs e ssl
    sudo mkdir -p "$home_dir/public_html" "$home_dir/page_error" "$home_dir/logs" "$home_dir/ssl"
    echo "Pastas public_html, page_error, logs e ssl criadas em $home_dir."

    # Ajusta as permissões das pastas
    sudo chown -R "$usuario":"$usuario" "$home_dir/public_html" "$home_dir/page_error" "$home_dir/logs" "$home_dir/ssl"
    sudo chmod -R 755 "$home_dir/public_html" "$home_dir/page_error" "$home_dir/logs" "$home_dir/ssl"
    echo "Permissões ajustadas para o usuário $usuario."
}

# Função para ajustar permissões de pastas e arquivos
ajustar_permissoes() {
    local usuario="$1"
    local home_dir="/home/$usuario"

    # Verifica se o diretório home do usuário existe
    if [ ! -d "$home_dir" ]; then
        echo "O diretório home para o usuário $usuario não existe."
        return 1
    fi

    # Ajusta permissões de pastas para 0755
    find "$home_dir" -type d -exec chmod 0755 {} \;
    echo "Permissões de pastas ajustadas para 0755 em $home_dir."

    # Ajusta permissões de arquivos para 0644
    find "$home_dir" -type f -exec chmod 0644 {} \;
    echo "Permissões de arquivos ajustadas para 0644 em $home_dir."
}

# Função para criar um certificado SSL autoassinado
criar_certificado_ssl() {
    local dominio="$1"
    local usuario="$2"
    local home_dir="/home/$usuario/ssl"
    local certificado="$home_dir/${dominio}.crt"
    local chave="$home_dir/${dominio}.key"
    
    # Solicita informações ao usuário
    read -p "Informe o nome da Organização (O): " organizacao
    read -p "Informe a Unidade Organizacional (OU): " unidade_organizacional

    # Verifica se o diretório SSL existe, caso contrário, cria-o
    if [ ! -d "$home_dir" ]; then
        sudo mkdir -p "$home_dir"
        sudo chown "$usuario":"$usuario" "$home_dir"
    fi

    # Cria o certificado autoassinado
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout "$chave" -out "$certificado" \
        -subj "/C=BR/ST=Sao Paulo/L=Sao Paulo/O=$organizacao/OU=$unidade_organizacional/CN=$dominio"

    echo "Certificado SSL autoassinado criado com sucesso."
    echo "Certificado: $certificado"
    echo "Chave: $chave"
}

# Função que cria cabeçalho html
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

# Função que cria rodapé html
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
    TITLE="405 Página não encontrada."

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
    echo "Página 405 criada em $PATH_ERROR"
}

# Função que cria página de erro 500
create_page_500(){
    echo "Criando página 500 padrão..."
    USER_HOME=$1
    PAGE_ERROR_DIR="$USER_HOME/page_error"
    PATH_ERROR="$PAGE_ERROR_DIR/500.html"
    TITLE="500 Erro interno o servidor"

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
    echo "Página 500 criada em $PATH_ERROR"
}

# Função que cria página index
create_page_index(){
    echo "Criando página index"
    USER_HOME=$1
    PATH_DIR="$USER_HOME/public_html"
    PATH_FILE="$PATH_DIR/index.html"
    TITLE="Página principal de $2"

    # Criar cabeçalho HTML
    create_html_header "$PATH_FILE" "$TITLE"
    # Conteúdo da página
    echo '    <div class="bg">' >> "$PATH_FILE"
    echo '        <div class="centered-message">' >> "$PATH_FILE"
    echo "            <h1>$TITLE</h1>" >> "$PATH_FILE"
    echo '            <p>A página que você está acessando ainda está em construção.</p>' >> "$PATH_FILE"
    echo '            <a href="/" class="btn btn-primary">Voltar para a página inicial</a>' >> "$PATH_FILE"
    echo '        </div>' >> "$PATH_FILE"
    echo '    </div>' >> "$PATH_FILE"
    # Criar rodapé HTML
    create_html_footer "$PATH_FILE"
    echo "Página index criada em $PATH_FILE"
}

# Função que cria página index
create_page_info_php(){
    echo "Criando página info.php"
    USER_HOME=$1
    PATH_DIR="$USER_HOME/public_html"
    PATH_FILE="$PATH_DIR/info.php"
    
    echo "<?php phpinfo();?>" >> "$PATH_FILE" 
    echo "Página de informações do php criada em $PATH_FILE"
}

# Cria o arquivo padrão do domínio 
create_site_apache(){
    DOMINIO=$1
    USUARIO=$2
    SSL_DIR="/home/$USUARIO/ssl"
    CERTIFICADO="$SSL_DIR/$DOMINIO.crt"
    CHAVE="$SSL_DIR/$DOMINIO.key"
    APACHE_CONF="/etc/apache2/sites-available/$DOMINIO.conf"
    sudo cat > "$APACHE_CONF" << EOL
<VirtualHost *:80>
    ServerAdmin webmaster@$DOMINIO
    ServerName $DOMINIO
    ServerAlias www.$DOMINIO
    DocumentRoot /home/$USUARIO/public_html

    ErrorLog /home/$USUARIO/logs/error.log
    CustomLog /home/$USUARIO/logs/access.log combined

    <Directory "/home/$USUARIO/public_html">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorDocument 404 /page_error/404.html
    ErrorDocument 405 /page_error/405.html
    ErrorDocument 500 /page_error/500.html

    RewriteEngine On
    RewriteCond %{SERVER_NAME} =www.$DOMINIO [OR]
    RewriteCond %{SERVER_NAME} =$DOMINIO
    RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,NE,R=permanent]
</VirtualHost>

<IfModule mod_ssl.c>
    <VirtualHost *:443>
        ServerAdmin webmaster@$DOMINIO
        ServerName $DOMINIO
        ServerAlias www.$DOMINIO
        DocumentRoot /home/$USUARIO/public_html

        ErrorLog /home/$USUARIO/logs/error-ssl.log
        CustomLog /home/$USUARIO/logs/access-ssl.log combined

        SSLEngine on
        SSLCertificateFile $CERTIFICADO
        SSLCertificateKeyFile $CHAVE

        <Directory "/home/$USUARIO/public_html">
            Options Indexes FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>

        ErrorDocument 404 /page_error/404.html
        ErrorDocument 405 /page_error/405.html
        ErrorDocument 500 /page_error/500.html
    </VirtualHost>
</IfModule>
EOL

    # Habilita o site e os módulos necessários
    sudo a2ensite "$DOMINIO.conf"
    # Reinicia o Apache para aplicar as mudanças
    sudo systemctl restart apache2
}

# Extrai o nome do usuário
NOME_USUARIO=$(extrair_nome_usuario "$DOMINIO")
echo "Nome do usuário extraído: $NOME_USUARIO"

# Define o diretório home do usuário
USER_HOME="/home/$NOME_USUARIO"
USER_NAME="$NOME_USUARIO"

cria_usuario "$USER_NAME"
criar_pastas "$USER_NAME"
ajustar_permissoes "$USER_NAME"
criar_certificado_ssl "$DOMINIO_COMPLETO" "$USER_NAME"
create_page_404 "$USER_HOME"
create_page_405 "$USER_HOME"
create_page_500 "$USER_HOME"
create_page_index "$USER_HOME" "$DOMINIO_COMPLETO"
create_page_info_php "$USER_HOME"
create_site_apache "$DOMINIO_COMPLETO" "$USER_NAME"



