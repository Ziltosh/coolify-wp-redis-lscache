#!/bin/bash
set -euo pipefail

# Fonction pour installer WordPress
install_wordpress() {
    # Vérification si WordPress est déjà installé
    if [ ! -f /var/www/vhosts/localhost/html/wp-config.php ]; then
        # Téléchargement et installation de WordPress
        curl -O https://wordpress.org/latest.zip
        unzip latest.zip
        rm latest.zip
        mv wordpress/* .
        rm -rf wordpress
    fi
}

# Fonction pour remplacer les valeurs dans wp-config.php
setup_wp_config() {
    # Attente que le fichier wp-config.php soit disponible
    if [ ! -f /var/www/vhosts/localhost/html/wp-config.php ]; then
        cp /var/www/vhosts/localhost/html/wp-config-sample.php /var/www/vhosts/localhost/html/wp-config.php
    fi

    # Afficher les variables d'environnement
    echo "WORDPRESS_DB_NAME: ${WORDPRESS_DB_NAME}"
    echo "WORDPRESS_DB_USER: ${WORDPRESS_DB_USER}"
    echo "WORDPRESS_DB_PASSWORD: ${WORDPRESS_DB_PASSWORD}"
    echo "WORDPRESS_DB_HOST: ${WORDPRESS_DB_HOST}"
    echo "WORDPRESS_TABLE_PREFIX: ${WORDPRESS_TABLE_PREFIX}"

    # Configuration de la base de données
    sed -i "s/define( 'DB_NAME', '.*' );/define( 'DB_NAME', '${WORDPRESS_DB_NAME}' );/" /var/www/vhosts/localhost/html/wp-config.php
    sed -i "s/define( 'DB_USER', '.*' );/define( 'DB_USER', '${WORDPRESS_DB_USER}' );/" /var/www/vhosts/localhost/html/wp-config.php
    sed -i "s/define( 'DB_PASSWORD', '.*' );/define( 'DB_PASSWORD', '${WORDPRESS_DB_PASSWORD}' );/" /var/www/vhosts/localhost/html/wp-config.php
    sed -i "s/define( 'DB_HOST', '.*' );/define( 'DB_HOST', '${WORDPRESS_DB_HOST}' );/" /var/www/vhosts/localhost/html/wp-config.php
    
    # Configuration du préfixe des tables
    sed -i "s/\$table_prefix = 'wp_';/\$table_prefix = '${WORDPRESS_TABLE_PREFIX}';/" /var/www/vhosts/localhost/html/wp-config.php

    # Récupération des clés de sécurité
    curl -O https://api.wordpress.org/secret-key/1.1/salt
    sed -i '/#@-/r salt' wp-config.php
    sed -i '/#@+/,/#@-/d' wp-config.php
}

# Installation de WordPress
install_wordpress

# Configuration de WordPress
setup_wp_config

# Exécution de la commande fournie
exec "$@" 