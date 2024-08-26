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
done

# Extrai o nome do usuário
NOME_USUARIO=$(extrair_nome_usuario "$DOMINIO")
echo "Nome do usuário extraído: $NOME_USUARIO"

# Define o diretório home do usuário
USER_HOME="/home/$NOME_USUARIO"

sudo find "$OME_USUARIO" -type d -exec chmod 0755 {} \;
sudo find "$OME_USUARIO" -type f -exec chmod 0644 {} \;


# Cria os diretórios dentro da home do usuário
PUBLIC_HTML="$USER_HOME/public_html"
ERROR_PAGES_DIR="$USER_HOME/page_error"
LOG_DIR="$USER_HOME/logs"
sudo mkdir -p "$PUBLIC_HTML" "$ERROR_PAGES_DIR" "$LOG_DIR"

# Define permissões
sudo chown -R www-data:www-data "$USER_HOME"
sudo chmod -R 755 "$USER_HOME"

# Cria uma página index padrão
echo "<html><body><h1>Bem-vindo ao $DOMINIO</h1></body></html>" | sudo tee "$PUBLIC_HTML/index.html"

# Configuração do Apache
APACHE_CONF="/etc/apache2/sites-available/$DOMINIO.conf"

sudo cat > "$APACHE_CONF" << EOL
<VirtualHost *:80>
    ServerAdmin webmaster@$DOMINIO
    ServerName $DOMINIO
    ServerAlias www.$DOMINIO
    DocumentRoot $PUBLIC_HTML

    ErrorLog $LOG_DIR/error.log
    CustomLog $LOG_DIR/access.log combined

    <Directory "$PUBLIC_HTML">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorDocument 404 /page_error/404.html
    ErrorDocument 500 /page_error/500.html
</VirtualHost>
EOL

# Habilita o site e reinicia o Apache
sudo a2ensite "$DOMINIO.conf"
sudo systemctl reload apache2

echo "Configuração do domínio $DOMINIO concluída com sucesso."
