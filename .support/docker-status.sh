#!/bin/bash
# vim: set foldmethod=marker:

# DOCKER="🐳 "
DOCKER=""

timeout 2s docker ps -q 1> /dev/null

if [[ $? != 0 ]]; then
    echo "#[fg=red]${DOCKER}-#[fg=default]"
    exit 0
else
    echo -n "#[fg=green]${DOCKER}+#[fg=default]"
fi

( docker ps | grep --quiet "xsaatchi_catalog_redis_instance" ) || echo -n "#[fg=red]C#[fg=default]"
( docker ps | grep --quiet "xsaatchi_catalog_sidekiq_instance" ) || echo -n "#[fg=red]C#[fg=default]"
( docker ps | grep --quiet "xsaatchi_catalog_unicorn_instance" ) || echo -n "#[fg=red]C#[fg=default]"

( docker ps | grep --quiet "xsaatchi_couchbase_instance" ) || echo -n "#[fg=red]B#[fg=default]"
( docker ps | grep --quiet "xsaatchi_edge_instance" ) || echo -n "#[fg=red]D#[fg=default]"
( docker ps | grep --quiet "xsaatchi_mysql_instance" ) || echo -n "#[fg=red]M#[fg=default]"
( docker ps | grep --quiet "xsaatchi_solr_instance" ) || echo -n "#[fg=red]S#[fg=default]"
( docker ps | grep --quiet "xsaatchi_xgateway_instance" ) || echo -n "#[fg=red]G#[fg=default]"

( docker ps | grep --quiet "xsaatchi_easel_node_instance" ) || echo -n "#[fg=red]E#[fg=default]"

( docker ps | grep --quiet "xsaatchi_gallery_cache_memcached_instance" ) || echo -n "#[fg=red]G#[fg=default]"
( docker ps | grep --quiet "xsaatchi_gallery_fpm_instance" ) || echo -n "#[fg=red]G#[fg=default]"
( docker ps | grep --quiet "xsaatchi_gallery_nginx_instance" ) || echo -n "#[fg=red]G#[fg=default]"
( docker ps | grep --quiet "xsaatchi_gallery_session_redis_instance" ) || echo -n "#[fg=red]G#[fg=default]"

( docker ps | grep --quiet "xsaatchi_imgpproc_redis_instance" ) || echo -n "#[fg=red]I#[fg=default]"
( docker ps | grep --quiet "xsaatchi_imgpproc_wsgi_instance" ) || echo -n "#[fg=red]I#[fg=default]"

( docker ps | grep --quiet "xsaatchi_legacy_fpm_instance" ) || echo -n "#[fg=red]L#[fg=default]"
( docker ps | grep --quiet "xsaatchi_legacy_gotifier_instance" ) || echo -n "#[fg=red]L#[fg=default]"
( docker ps | grep --quiet "xsaatchi_legacy_nginx_instance" ) || echo -n "#[fg=red]L#[fg=default]"
( docker ps | grep --quiet "xsaatchi_legacy_session_memcached_instance" ) || echo -n "#[fg=red]L#[fg=default]"

( docker ps | grep --quiet "xsaatchi_palette_fpm_instance" ) || echo -n "#[fg=red]P#[fg=default]"
( docker ps | grep --quiet "xsaatchi_palette_nginx_instance" ) || echo -n "#[fg=red]P#[fg=default]"

( docker ps | grep --quiet "xsaatchi_yves_fpm_instance" ) || echo -n "#[fg=red]Z#[fg=default]"
( docker ps | grep --quiet "xsaatchi_zed_fpm_instance" ) || echo -n "#[fg=red]Z#[fg=default]"
( docker ps | grep --quiet "xsaatchi_zed_memcached_instance" ) || echo -n "#[fg=red]Z#[fg=default]"
( docker ps | grep --quiet "xsaatchi_zed_nginx_instance" ) || echo -n "#[fg=red]Z#[fg=default]"

echo ''

