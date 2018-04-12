#!/bin/zsh
# vim: set foldmethod=marker ft=zsh:

# misc {{{
# alias saatchi-puppet-apply="ssh saatchi-console-01 -t 'cd puppet && git pull && cd - && ./apply-puppet'"

alias saatchi-sns-list-topics-east="aws sns list-topics --profile=east | awk '{print \$2}' | awk -F":" '{print \$6}'"
alias saatchi-sns-list-topics-west="aws sns list-topics --profile=west | awk '{print \$2}' | awk -F":" '{print \$6}'"

alias saatchi-visii-monitor="autossh saatchi-xprod-legacy-services-02 -t \"screen -dAR mike.funk\""
# }}}

# dirs {{{
CATALOG_DIR="$HOME/Code/saatchi/catalog"
API_DIR="$HOME/Code/saatchi/api"
LEGACY_DIR="$HOME/Code/saatchi/saatchiart"
PALETTE_DIR="$HOME/Code/saatchi/palette"
GALLERY_DIR="$HOME/Code/saatchi/gallery"
EASEL_DIR="$HOME/Code/saatchi/easel"
ZED_DIR="$HOME/Code/saatchi/zed"
LB_DIR="$HOME/Code/saatchi/lb"
MYSQL_DIR="$HOME/Code/saatchi/mysql"
IMGPROC_DIR="$HOME/Code/saatchi/imgproc"
XDOCKER_DIR="$HOME/Code/saatchi/xdocker"
# }}}

# saatchi docker restart commands {{{
alias saatchi-restart-catalog-local="dme && cd $XDOCKER_DIR/apps/catalog && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-api-local="dme && cd $XDOCKER_DIR/apps/api && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-legacy-local="dme && cd $XDOCKER_DIR/apps/legacy && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-palette-local="dme && cd $XDOCKER_DIR/apps/palette && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-gallery-local="dme && cd $XDOCKER_DIR/apps/gallery && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-easel-local="dme && cd $XDOCKER_DIR/apps/easel && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-zed-local="dme && cd $XDOCKER_DIR/apps/zed && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-lb-local="dme && cd $XDOCKER_DIR/apps/lb && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-mysql-local="dme && cd $XDOCKER_DIR/apps/mysql && docker-compose stop && docker-compose up --force-recreate -d && cd -"
alias saatchi-restart-imgproc-local="dme && cd $XDOCKER_DIR/apps/imgproc && docker-compose stop && docker-compose up --force-recreate -d && cd -"
# }}}

# temporary commands to fix logs in docker containers {{{
alias saatchi-fix-logs-legacy-fpm="saatchi-docker-legacy-fpm bash -c \"touch /data/temp/saatchi.log && \
    chmod a+w /data/temp/saatchi.log\""
alias saatchi-fix-logs-zed-fpm="saatchi-docker-zed-fpm bash -c \"mkdir -p /scratch/yzed/data/US/logs/ZED && \
    touch /scratch/yzed/data/US/logs/ZED/exception.log && \
    chmod -R a+w /scratch/yzed/data/US/logs\""
# }}}

# saatchi tail commands {{{
# requires `brew install multitail`

# local {{{
alias saatchi-tail-lb-local="dme && multitail \
-CS lb -l 'docker exec -ti xsaatchi_lb_instance tail -f -n500 /var/log/haproxy.log' \
-ts -M 3000"

alias saatchi-tail-legacy-local="saatchi-fix-logs-legacy-fpm && multitail \
-CS legacy -l 'docker exec -ti xsaatchi_legacy_fpm_instance tail -n500 -f /data/temp/saatchi.log' \
-CS legacy -L 'docker exec -ti xsaatchi_legacy_nginx_instance tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log | grep -v healthcheck' \
-ts -M 3000"

alias saatchi-tail-zed-local="saatchi-fix-logs-zed-fpm && multitail \
-CS zed -l 'docker exec -ti xsaatchi_zed_nginx_instance tail -n500 -f /var/log/nginx/error.log /var/log/nginx/zed.error.log' \
-CS zed -L 'docker exec -ti xsaatchi_zed_fpm_instance tail -n500 -f /scratch/yzed/data/US/logs/ZED/*.log' \
-ts -M 3000"

alias saatchi-tail-palette-local="dme && multitail \
-CS palette -l 'docker exec -ti xsaatchi_palette_fpm_instance tail -n500 -f /scratch/palette/log/general-laravel.log' \
-CS palette -L 'docker exec -ti xsaatchi_palette_nginx_instance tail -n500 -f /var/log/nginx/error.log /var/log/nginx/palette.error.log' \
-ts -M 3000"

alias saatchi-tail-gallery-local="dme && multitail \
-CS gallery -l 'docker exec -ti xsaatchi_gallery_nginx_instance tail -n500 -f /var/log/nginx/error.log /var/log/nginx/www.error.log' \
-CS gallery -L 'docker exec -ti xsaatchi_gallery_fpm_instance tail -n500 -f /data/gallery/current/storage/logs/laravel.log' \
-ts -M 3000"

# no pm2 in easel
# alias saatchi-tail-easel-local="dme && multitail -CS easel -l 'docker exec -ti xsaatchi_easel_node_instance /usr/local/node/node-default/bin/pm2 logs --timestamp --lines=500 --err' -ts -M 3000"
alias saatchi-tail-catalog-local="dme && multitail -CS catalog -Ev \"AWS SQS 200\" -cT ANSI \
-l 'docker exec -ti xsaatchi_catalog_unicorn_instance tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/local.log' \
-ts -M 3000"

alias saatchi-tail-api-local="dme && multitail -CS api -Ev \"AWS SQS 200\" \
-l 'docker exec -ti xsaatchi_api_unicorn_instance tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/api/current/log/local.log' \
-ts -M 3000"

# directory doesn't exist...
# alias saatchi-tail-imgproc-local="dme && multitail -l 'docker exec -ti xsaatchi_imgproc_node_instance tail -n500 -f /scratch/log/imgproc/*' -ts -M 3000"
# }}}

# xdev {{{
alias saatchi-tail-legacy-xdev="multitail -CS legacy \
-Ev \"REQUEST ART CREATE\" \
-Ev \"RESPONSE ART CREATE\" \
-Ev \"healthcheck\" \
-l 'autossh appdeploy@saatchi-xdev-legacy-01 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log /data/temp/saatchi.log\"' \
-ts -M 3000"

alias saatchi-tail-catalog-xdev="multitail -CS catalog \
-Ev \"heartbeat\" \
-Ev \"AWS SQS 200\" -cT ANSI \
-l 'autossh -t appdeploy@saatchi-xdev-catalog-01 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/development.log\"' \
-ts -M 3000"

alias saatchi-tail-api-xdev="multitail -CS api \
-Ev \"End Point\" \
-Ev \"\*{5}\" \
-l 'autossh -t appdeploy@saatchi-xdev-catalog-01 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/development.log\"' \
-ts -M 3000"

alias saatchi-tail-legacy-services-xdev="multitail -CS legacy \
-l 'autossh -t appdeploy@saatchi-xdev-legacy-services-01 \"tail -n500 -f /data/temp/saatchi.log\"' \
-ts -M 3000"

alias saatchi-tail-zed-xdev="multitail -CS zed \
-l 'autossh -t appdeploy@saatchi-xdev-zed-01 \"tail -n500 -f \
/var/log/nginx/error.log \
/var/log/nginx/static.error.log \
/var/log/nginx/zed.error.log \
/var/log/nginx/yves.error.log \
/scratch/yzed/data/US/logs/YVES/*.log \
/scratch/yzed/data/US/logs/ZED/*.log\"' \
-ts -M 3000"

alias saatchi-tail-gallery-xdev="multitail -CS gallery \
-l 'autossh -t appdeploy@saatchi-xdev-gallery-01 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/www.error.log /data/gallery/current/storage/logs/laravel.log\"' \
-ts -M 3000"

alias saatchi-tail-easel-xdev="multitail -CS easel \
-l 'autossh -t appdeploy@saatchi-xdev-gallery-01 \"/usr/local/node/node-default/bin/pm2 logs --timestamp --lines=500\"' \
-ts -M 3000"

alias saatchi-tail-palette-xdev="multitail -CS palette \
-l 'autossh -t appdeploy@saatchi-xdev-palette-01 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/app.error.log /scratch/palette/log/general-laravel.log /scratch/palette/log/saatchi-ecommerce.log\"' \
-ts -M 3000"

alias saatchi-tail-palette-services-xdev="multitail -CS palette \
-l 'autossh -t appdeploy@saatchi-xdev-palette-services-01 \"tail -n500 -f \
/var/log/nginx/error.log \
/var/log/nginx/app.error.log \
/scratch/palette/log/general-laravel.log \
/scratch/palette/log/saatchi-ecommerce.log\"' \
-ts -M 3000"

alias saatchi-tail-lb-xdev="multitail -CS lb \
-l 'autossh -t appdeploy@saatchi-xdev-lb-01 \"sudo tail -n500 -f /var/log/haproxy.log\"' \
-ts -M 3000"

# log file seems to be /scratch/log/imgproc/imgproc.log.gz
alias saatchi-tail-imgproc-xdev="multitail -cT ANSI \
-l 'autossh -t saatchi-xdev-origin-01 tail -n500 -f /scratch/log/imgproc/imgproc.log'"
# }}}

# xqa {{{
alias saatchi-tail-legacy-xqa="multitail -CS legacy \
-Ev \"REQUEST ART CREATE\" \
-Ev \"RESPONSE ART CREATE\" \
-Ev \"healthcheck\" \
-l 'autossh -t appdeploy@saatchi-xqa-legacy-01 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log /data/temp/saatchi.log\"' \
-L 'autossh -t appdeploy@saatchi-xqa-legacy-02 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log /data/temp/saatchi.log\"' \
-ts -M 3000"

alias saatchi-tail-catalog-xqa="multitail -CS catalog  \
-Ev \"heartbeat\" \
-Ev \"AWS SQS 200\" \
-cT ANSI -l 'autossh -t saatchi-xqa-catalog-01 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/qa.log\"' \
-cT ANSI -L 'autossh -t saatchi-xqa-catalog-02 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/qa.log\"' \
-ts -M 3000"

alias saatchi-tail-api-xqa="multitail -CS api \
-Ev \"End Point\" \
-Ev \"\*{5}\" \
-cT ANSI -l 'autossh -t saatchi-xqa-catalog-01 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/qa.log\"' \
-cT ANSI -L 'autossh -t saatchi-xqa-catalog-02 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/qa.log\"' \
-ts -M 3000"

alias saatchi-tail-legacy-services-xqa="multitail -CS legacy \
-Ev \"REQUEST ART CREATE\" \
-Ev \"RESPONSE ART CREATE\" \
-l 'autossh -t saatchi-xqa-legacy-services-01 \"tail -n500 -f /data/temp/saatchi.log\"' \
-ts -M 3000"

alias saatchi-tail-zed-xqa="multitail -CS zed \
-l 'autossh -t appdeploy@saatchi-xqa-zed-01 \"tail -n500 -f \
/var/log/nginx/error.log \
/var/log/nginx/static.error.log \
/var/log/nginx/zed.error.log \
/var/log/nginx/yves.error.log \
/scratch/yzed/data/US/logs/YVES/*.log \
/scratch/yzed/data/US/logs/ZED/*.log\"' \
-ts -M 3000"

alias saatchi-tail-gallery-xqa="multitail -CS gallery \
-l 'autossh -t appdeploy@saatchi-xqa-gallery-01 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/www.error.log /data/gallery/current/storage/logs/laravel.log\"' \
-L 'autossh -t appdeploy@saatchi-xqa-gallery-02 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/www.error.log /data/gallery/current/storage/logs/laravel.log\"' \
-ts -M 3000"

alias saatchi-tail-easel-xqa="multitail -CS easel \
-l 'autossh -t appdeploy@saatchi-xqa-gallery-01 \"/usr/local/node/node-default/bin/pm2 logs --timestamp --lines=500\"' \
-L 'autossh -t appdeploy@saatchi-xqa-gallery-02 \"/usr/local/node/node-default/bin/pm2 logs --timestamp --lines=500\"' \
-ts -M 3000"

alias saatchi-tail-palette-xqa="multitail -CS palette \
-l 'autossh -t appdeploy@saatchi-xqa-palette-01 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/app.error.log /scratch/palette/log/general-laravel.log /scratch/palette/log/saatchi-ecommerce.log\"' \
-L 'autossh -t appdeploy@saatchi-xqa-palette-02 \"tail -n500 -f /var/log/nginx/error.log /var/log/nginx/app.error.log /scratch/palette/log/general-laravel.log /scratch/palette/log/saatchi-ecommerce.log\"' \
-ts -M 3000"

alias saatchi-tail-palette-services-xqa="multitail -CS palette \
-l 'autossh -t appdeploy@saatchi-xqa-palette-services-01 \"tail -n500 -f \
/var/log/nginx/error.log \
/var/log/nginx/app.error.log \
/scratch/palette/log/general-laravel.log \
/scratch/palette/log/saatchi-ecommerce.log\"' \
-ts -M 3000"

alias saatchi-tail-lb-xqa="multitail -CS lb \
-l 'autossh -t appdeploy@saatchi-xqa-lb-01 \"sudo tail -n500 -f /var/log/haproxy.log\"' \
-ts -M 3000"

# log file seems to be /scratch/imgproc/imgproc.log.gz
# alias saatchi-tail-imgproc-xqa="multitail -cT ANSI -l 'autossh -t saatchi-xqa-origin-01 tail -n500 -f /var/log/imgproc/imgproc.log' -cT ANSI -L 'autossh -t saatchi-xqa-origin-02 tail -n500 -f /var/log/imgproc/imgproc.log'"
alias saatchi-tail-imgproc-xqa="multitail \
-cT ANSI -l 'autossh -t saatchi-xqa-origin-01 tail -n500 -f /scratch/log/imgproc/imgproc.log' \
-cT ANSI -L 'autossh -t saatchi-xqa-origin-02 tail -n500 -f /scratch/log/imgproc/imgproc.log'"
# }}}

# xprod {{{
alias saatchi-tail-legacy-xprod="multitail -CS legacy \
-Ev \"REQUEST ART CREATE\" \
-Ev \"RESPONSE ART CREATE\" \
-Ev \"healthcheck\" \
-l 'autossh -t appdeploy@saatchi-xprod-legacy-01 \"tail -n500 -f /data/temp/saatchi.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-02 \"tail -n500 -f /data/temp/saatchi.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-03 \"tail -n500 -f /data/temp/saatchi.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-04 \"tail -n500 -f /data/temp/saatchi.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-05 \"tail -n500 -f /data/temp/saatchi.log\"' \
-ts -M 3000"

# needs www-data to access nginx logs. Even appdeploy doesn't have aaccess to those.
alias saatchi-tail-legacy-nginx-xprod="multitail -CS legacy \
-Ev \"REQUEST ART CREATE\" \
-Ev \"RESPONSE ART CREATE\" \
-Ev \"healthcheck\" \
-l 'autossh -t appdeploy@saatchi-xprod-legacy-01 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-02 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-03 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-04 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-legacy-05 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/legacy.error.log /var/log/nginx/upload.error.log\"' \
-ts -M 3000"

alias saatchi-tail-catalog-xprod="multitail -CS catalog \
-Ev \"heartbeat\" \
-Ev \"AWS SQS 200\" \
-l 'autossh -t saatchi-xprod-catalog-01 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/orders.log /data/catalog/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-02 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/orders.log /data/catalog/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/orders.log /data/catalog/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/orders.log /data/catalog/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-04 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/orders.log /data/catalog/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-05 \"tail -n500 -f /data/catalog/shared/log/unicorn.stderr.log /data/catalog/current/log/orders.log /data/catalog/current/log/production.log\"' \
-ts -M 3000"

alias saatchi-tail-sidekiq-xprod="multitail -CS catalog \
-Ev \"heartbeat\" \
-Ev \"AWS SQS 200\" \
-l 'autossh -t saatchi-xprod-catalog-01 \"tail -n500 -f /data/catalog/current/log/sidekiq.log\"' \
-L 'autossh -t saatchi-xprod-catalog-02 \"tail -n500 -f /data/catalog/current/log/sidekiq.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/catalog/current/log/sidekiq.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/catalog/current/log/sidekiq.log\"' \
-L 'autossh -t saatchi-xprod-catalog-04 \"tail -n500 -f /data/catalog/current/log/sidekiq.log\"' \
-L 'autossh -t saatchi-xprod-catalog-05 \"tail -n500 -f /data/catalog/current/log/sidekiq.log\"' \
-ts -M 3000"

alias saatchi-tail-catalog-orders-xprod="multitail -CS catalog \
-Ev \"heartbeat\" -Ev \"AWS SQS 200\" \
-l 'autossh -t saatchi-xprod-catalog-01 \"tail -n500 -f /data/catalog/current/log/orders.log\"' \
-L 'autossh -t saatchi-xprod-catalog-02 \"tail -n500 -f /data/catalog/current/log/orders.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/catalog/current/log/orders.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/catalog/current/log/orders.log\"' \
-L 'autossh -t saatchi-xprod-catalog-04 \"tail -n500 -f /data/catalog/current/log/orders.log\"' \
-L 'autossh -t saatchi-xprod-catalog-05 \"tail -n500 -f /data/catalog/current/log/orders.log\"' \
-ts -M 3000"

alias saatchi-tail-api-xprod="multitail -CS api \
-Ev \"End Point\" \
-Ev \"\*{5}\" \
-l 'autossh -t saatchi-xprod-catalog-01 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-02 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-03 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-04 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/production.log\"' \
-L 'autossh -t saatchi-xprod-catalog-05 \"tail -n500 -f /data/api/current/log/unicorn.stderr.log /data/api/current/log/production.log\"' \
-ts -M 3000"

alias saatchi-tail-legacy-services-xprod="multitail -CS legacy \
-Ev \"REQUEST ART CREATE\" \
-Ev \"RESPONSE ART CREATE\" \
-l 'autossh -t saatchi-xprod-legacy-services-02 \"tail -n500 -f /data/temp/saatchi.log\"' \
-ts -M 3000"

alias saatchi-tail-zed-xprod="multitail -CS zed \
-l 'autossh -t appdeploy@saatchi-xprod-zed-02 \"tail -n500 -f \
/var/log/nginx/error.log \
/var/log/nginx/static.error.log \
/var/log/nginx/zed.error.log \
/var/log/nginx/yves.error.log \
/scratch/yzed/data/US/logs/YVES/*.log \
/scratch/yzed/data/US/logs/ZED/*.log\"' \
-ts -M 3000"

alias saatchi-tail-zed-exception-log-xprod="multitail -CS zed \
-l 'autossh -t appdeploy@saatchi-xprod-zed-02 \"tail -n500 -f /scratch/yzed/data/US/logs/ZED/exception.log\"' \
-ts -M 3000"
alias saatchi-tail-gallery-xprod="multitail -CS gallery \
-l 'autossh -t appdeploy@saatchi-xprod-gallery-01 \"tail -n500 -f /data/gallery/current/storage/logs/laravel.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-gallery-02 \"tail -n500 -f /data/gallery/current/storage/logs/laravel.log\"' \
-ts -M 3000"

# needs www-data to access nginx logs. Even appdeploy doesn't have aaccess to those.
alias saatchi-tail-gallery-nginx-xprod="multitail -CS gallery \
-l 'autossh -t appdeploy@saatchi-xprod-gallery-01 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/www.error.log /var/log/nginx/error.log /var/log/nginx/error.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-gallery-02 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/www.error.log /var/log/nginx/error.log /var/log/nginx/error.log\"' \
-ts -M 3000"

alias saatchi-tail-easel-xprod="multitail -CS easel \
-l 'autossh -t appdeploy@saatchi-xprod-gallery-01 \"/usr/local/node/node-default/bin/pm2 logs --timestamp --lines=500\"' \
-L 'autossh -t appdeploy@saatchi-xprod-gallery-02 \"/usr/local/node/node-default/bin/pm2 logs --timestamp --lines=500\"' \
-ts -M 3000"

alias saatchi-tail-palette-xprod="multitail -CS palette \
-l 'autossh -t appdeploy@saatchi-xprod-palette-01 \"tail -n500 -f /scratch/palette/log/general-laravel.log /scratch/palette/log/saatchi-ecommerce.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-palette-02 \"tail -n500 -f /scratch/palette/log/general-laravel.log /scratch/palette/log/saatchi-ecommerce.log\"' \
-ts -M 3000"

alias saatchi-tail-palette-services-xprod="multitail -CS palette \
-l 'autossh -t appdeploy@saatchi-xprod-palette-services-01 \"tail -n500 -f \
/var/log/nginx/error.log \
/var/log/nginx/app.error.log \
/scratch/palette/log/general-laravel.log \
/scratch/palette/log/saatchi-ecommerce.log\"' \
-ts -M 3000"

alias saatchi-tail-palette-nginx-xprod="multitail -CS palette \
-l 'autossh -t appdeploy@saatchi-xprod-palette-01 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/app.error.log\"' \
-L 'autossh -t appdeploy@saatchi-xprod-palette-02 \"sudo -u www-data tail -n500 -f /var/log/nginx/error.log /var/log/nginx/app.error.log\"' \
-ts -M 3000"

# FIREHOSE! Note: needs sudo to access log, but sudo prevents process from being stopped automatically. Be sure to stop process afterward!
alias saatchi-tail-lb-xprod="multitail -CS lb \
-l 'autossh -t appdeploy@saatchi-xprod-lb-01 sudo tail -n500 -f /var/log/haproxy.log' \
-L 'autossh -t appdeploy@saatchi-xprod-lb-02 sudo tail -n500 -f /var/log/haproxy.log' \
-ts -M 3000"

# no access to apache logs
alias saatchi-tail-imgproc-xprod="multitail \
-cT ANSI -l 'autossh -t saatchi-xprod-origin-01 tail -n500 -f /scratch/log/imgproc/imgproc.log' \
-cT ANSI -L 'autossh -t saatchi-xprod-origin-02 tail -n500 -f /scratch/log/imgproc/imgproc.log' \
-cT ANSI -L 'autossh -t saatchi-xprod-origin-03 tail -n500 -f /scratch/log/imgproc/imgproc.log' \
-cT ANSI -L 'autossh -t saatchi-xprod-origin-04 tail -n500 -f /scratch/log/imgproc/imgproc.log' \
-cT ANSI -L 'autossh -t saatchi-xprod-origin-05 tail -n500 -f /scratch/log/imgproc/imgproc.log'"
# }}}
# }}}

# saatchi - get id_user_art by art id. {{{
saatchi-id-user-art-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-art-local {art_id}"; return; fi;
    export MYSQL_PWD=$SAATCHI_LOCAL_PASSWORD && \
        mysql -h $SAATCHI_LOCAL_HOST \
        -u $SAATCHI_LOCAL_USERNAME \
        -D $SAATCHI_LOCAL_DB \
        --port=$SAATCHI_LOCAL_PORT \
        --execute "select id_user_art from user_art where id = $1;" \
        --batch -N;
}
saatchi-id-user-art-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-art-xdev {art_id}"; return; fi;
    ssh -f saatchi-console-01 \
        -L $SAATCHI_XDEV_TUNNEL_PORT:$SAATCHI_XDEV_HOST:$SAATCHI_XDEV_PORT -N && \
        export MYSQL_PWD=$SAATCHI_XDEV_PASSWORD && \
        mysql -h127.0.0.1 \
        -P$SAATCHI_XDEV_TUNNEL_PORT \
        -u$SAATCHI_XDEV_USERNAME \
        -D$SAATCHI_XDEV_DB \
        --execute "select id_user_art from user_art where id = $1;" \
        --batch -N;
}

saatchi-id-user-art-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-art-xqa {art_id}"; return; fi;
    ssh -f saatchi-console-01 \
        -L $SAATCHI_XQA_TUNNEL_PORT:$SAATCHI_XQA_HOST:$SAATCHI_XQA_PORT \
        -N && export MYSQL_PWD=$SAATCHI_XQA_PASSWORD && \
        mysql -h127.0.0.1 \
        -P$SAATCHI_XQA_TUNNEL_PORT \
        -u$SAATCHI_XQA_USERNAME \
        -D$SAATCHI_XQA_DB \
        --execute "select id_user_art from user_art where id = $1;" \
        --batch -N;
}

saatchi-id-user-art-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-art-xprod {art_id}"; return; fi;
        ssh -f saatchi-console-01 \
            -L 2567:$SAATCHI_XPROD_HOST:$SAATCHI_XPROD_PORT \
            -N && export MYSQL_PWD=$SAATCHI_XPROD_PASSWORD && \
            mysql -h127.0.0.1 \
            -P2567 \
            -u$SAATCHI_XPROD_USERNAME \
            -D$SAATCHI_XPROD_DB \
            --execute "select id_user_art from user_art where id = $1;" \
            --batch -N;
}

# copy to clipboard
# saatchi-id-user-art-local-copy () { saatchi-id-user-art-local $1 | head -n1 | tr -d '\n' | pbcopy; }
# saatchi-id-user-art-xdev-copy () { saatchi-id-user-art-xdev $1 | head -n1 | tr -d '\n' | pbcopy; }
# saatchi-id-user-art-xqa-copy () { saatchi-id-user-art-xqa $1 | head -n1 | tr -d '\n' | pbcopy; }
# saatchi-id-user-art-xprod-copy () { saatchi-id-user-art-xprod $1 | head -n1 | tr -d '\n' | pbcopy; }
# }}}

# saatchi - get id_user_collection by collection id. {{{
saatchi-id-user-collection-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-collection-local {collection_id}"; return; fi;
    mysql -h $SAATCHI_LOCAL_HOST \
        -u $SAATCHI_LOCAL_USERNAME \
        -D $SAATCHI_LOCAL_DB \
        --execute "select id_user_collection from user_collections where id = $1;" \
        --batch -N;
}
saatchi-id-user-collection-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-collection-xdev {collection_id}"; return; fi;
    ssh -f saatchi-console-01 \
        -L $SAATCHI_XDEV_TUNNEL_PORT:$SAATCHI_XDEV_HOST:$SAATCHI_XDEV_PORT -N && \
        export MYSQL_PWD=$SAATCHI_XDEV_PASSWORD && \
        mysql -h127.0.0.1 \
        -P$SAATCHI_XDEV_TUNNEL_PORT \
        -u$SAATCHI_XDEV_USERNAME \
        -D$SAATCHI_XDEV_DB \
        --execute "select id_user_collection from user_collections where id = $1;" \
        --batch -N;
}
saatchi-id-user-collection-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-collection-xqa {collection_id}"; return; fi;
    ssh -f saatchi-console-01 \
        -L 8307:$SAATCHI_XQA_HOST:$SAATCHI_XQA_PORT -N && \
        export MYSQL_PWD=$SAATCHI_XQA_PASSWORD && \
        mysql -h127.0.0.1 \
        -P8307 \
        -u$SAATCHI_XQA_USERNAME \
        -D$SAATCHI_XQA_DB \
        --execute "select id_user_collection from user_collections where id = $1;" \
        --batch -N;
}
saatchi-id-user-collection-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-id-user-collection-xprod {collection_id}"; return; fi; \
    ssh -f saatchi-console-01 \
        -L 8307:$SAATCHI_XPROD_HOST:$SAATCHI_XPROD_PORT -N && \
        export MYSQL_PWD=$SAATCHI_XPROD_PASSWORD && \
        mysql -h127.0.0.1 \
        -P8307 \
        -u$SAATCHI_XPROD_USERNAME \
        -D$SAATCHI_XPROD_DB \
        --execute "select id_user_collection from user_collections where id = $1;" \
        --batch -N;
}
# }}}

# saatchi socks proxies {{{
# used to connect to web admins for solr and couchbase via switchyomega chrome extension
# should not need this any more now that it's a launchd service
alias saatchi-proxy="autossh saatchi-console-proxy -N &"
# }}}

# saatchi mycli aliases {{{
# mycli is a pretty mysql helper - `brew install mycli`

### local {{{
alias saatchi-mycli-legacy-local="mycli -h $SAATCHI_LOCAL_HOST \
-u $SAATCHI_LOCAL_USERNAME \
-D $SAATCHI_LOCAL_DB \
--password="" \
--prompt 'saatchi[local]> ' \
--auto-vertical-output"

alias saatchi-mycli-zed-local="mycli -h $ZED_LOCAL_HOST \
-u $ZED_LOCAL_USERNAME \
-D $ZED_LOCAL_DB \
--password="" \
--prompt 'zed[local]> ' \
--auto-vertical-output"

alias saatchi-mycli-palette-local="mycli -h $PALETTE_LOCAL_HOST \
-u $PALETTE_LOCAL_USERNAME \
-D $PALETTE_LOCAL_DB \
--password="" \
--prompt 'palette[local]> ' \
--auto-vertical-output"
#}}}

# xdev {{{
alias saatchi-mycli-legacy-xdev="autossh -f saatchi-console-01 \
-L $SAATCHI_XDEV_TUNNEL_PORT:$SAATCHI_XDEV_HOST:$SAATCHI_XDEV_PORT \
-N && export MYSQL_PWD=$SAATCHI_XDEV_PASSWORD && \
mycli -h localhost \
-u $SAATCHI_XDEV_USERNAME \
-D $SAATCHI_XDEV_DB \
--port=$SAATCHI_XDEV_TUNNEL_PORT \
--prompt 'saatchi[xdev]> ' \
--auto-vertical-output --warn"

alias saatchi-mycli-palette-xdev="autossh -f saatchi-console-01 \
-L $PALETTE_XDEV_TUNNEL_PORT:$PALETTE_XDEV_HOST:$PALETTE_XDEV_PORT \
-N && export MYSQL_PWD=$PALETTE_XDEV_PASSWORD && \
mycli -h localhost \
-u $PALETTE_XDEV_USERNAME \
-D $PALETTE_XDEV_DB \
--port=$PALETTE_XDEV_TUNNEL_PORT \
--prompt 'palette[xdev]> ' \
--auto-vertical-output --warn"

alias saatchi-mycli-zed-xdev="autossh -f saatchi-console-01 \
-L $ZED_XDEV_TUNNEL_PORT:$ZED_XDEV_HOST:$ZED_XDEV_PORT \
-N && export MYSQL_PWD=$ZED_XDEV_PASSWORD && \
mycli -h localhost \
-u $ZED_XDEV_USERNAME \
-D $ZED_XDEV_DB \
--port=$ZED_XDEV_TUNNEL_PORT \
--prompt 'zed[xdev]> ' \
--auto-vertical-output --warn"
#}}}

# xqa {{{
alias saatchi-mycli-legacy-xqa="autossh -f saatchi-console-01 -L $SAATCHI_XQA_TUNNEL_PORT:$SAATCHI_XQA_HOST:$SAATCHI_XQA_PORT -N && export MYSQL_PWD=$SAATCHI_XQA_PASSWORD && mycli -h localhost -u $SAATCHI_XQA_USERNAME -D $SAATCHI_XQA_DB --port=$SAATCHI_XQA_TUNNEL_PORT --prompt 'saatchi[xqa]> ' --auto-vertical-output --warn"
alias saatchi-mycli-zed-xqa="autossh -f saatchi-console-01 -L $ZED_XQA_TUNNEL_PORT:$ZED_XQA_HOST:3306 -N && export MYSQL_PWD=$ZED_XQA_PASSWORD && mycli -h127.0.0.1 -P$ZED_XQA_TUNNEL_PORT -u$ZED_XQA_USERNAME -D$ZED_XQA_DB --prompt 'zed[xqa]> ' --auto-vertical-output --warn"
alias saatchi-mycli-palette-xqa="autossh -f saatchi-console-01 -L $PALETTE_XQA_TUNNEL_PORT:$PALETTE_XQA_HOST:$PALETTE_XQA_PORT -N && export MYSQL_PWD=$PALETTE_XQA_PASSWORD && mycli -h localhost -u $PALETTE_XQA_USERNAME -D $PALETTE_XQA_DB --port=$PALETTE_XQA_TUNNEL_PORT --prompt 'palette[xqa]> ' --auto-vertical-output --warn"
#}}}

# prod {{{
alias saatchi-mycli-legacy-xprod="autossh -f saatchi-console-01 -L 5381:$SAATCHI_XPROD_HOST:$SAATCHI_XPROD_PORT -N && \
    export MYSQL_PWD=$SAATCHI_XPROD_PASSWORD && \
    mycli -h localhost -u $SAATCHI_XPROD_USERNAME -D $SAATCHI_XPROD_DB --port=5381 --prompt 'legacy[PRODUCTION]> ' --auto-vertical-output --warn"
alias saatchi-mycli-legacy-xprod-read-only="autossh -f saatchi-console-01 -L 5381:$SAATCHI_REPLICA_HOST:$SAATCHI_REPLICA_PORT -N && \
    export MYSQL_PWD=$SAATCHI_REPLICA_PASSWORD && \
    mycli -h localhost -u $SAATCHI_REPLICA_USERNAME -D $SAATCHI_REPLICA_DB --port=5381 --prompt 'legacy[PRODUCTION:READ-ONLY]> ' --auto-vertical-output --warn"
alias saatchi-mycli-zed-xprod="autossh -f saatchi-console-01 -L 6783:$ZED_XPROD_HOST:$ZED_XPROD_PORT -N && \
    export MYSQL_PWD=$ZED_XPROD_PASSWORD && mycli -h localhost -u $ZED_XPROD_USERNAME -D $ZED_XPROD_DB --port=6783 --prompt 'zed[PRODUCTION]> ' --auto-vertical-output --warn"
alias saatchi-mycli-zed-xprod-read-only="autossh -f saatchi-console-01 -L 7733:$ZED_REPLICA_HOST:$ZED_REPLICA_PORT -N && \
    export MYSQL_PWD=$ZED_REPLICA_PASSWORD && \
    mycli -h localhost -u $ZED_REPLICA_USERNAME -D $ZED_REPLICA_DB --port=7733 --prompt 'zed[PRODUCTION:READ-ONLY]> ' --auto-vertical-output --warn"
alias saatchi-mycli-palette-xprod="autossh -f saatchi-console-01 -L 4913:$PALETTE_PROD_HOST:3306 -N && \
    export MYSQL_PWD=$PALETTE_PROD_PASSWORD && \
    mycli -h127.0.0.1 -P4913 -u$PALETTE_PROD_USERNAME -D$PALETTE_PROD_DB --prompt 'palette[PRODUCTION]> ' --auto-vertical-output --warn"
alias saatchi-mycli-palette-xreplica-ready-only="autossh -f saatchi-console-01 -L 4913:$PALETTE_REPLICA_HOST:3306 -N && \
    export MYSQL_PWD=$PALETTE_REPLICA_PASSWORD && \
    mycli -h127.0.0.1 -P4913 -u$PALETTE_REPLICA_USERNAME -D$PALETTE_REPLICA_DB --prompt 'palette[PRODUCTION:READ-ONLY]> ' --auto-vertical-output --warn"

# do we have a xsaatchi version of this?
alias saatchi-mycli-legacy-xprod-greensql="autossh -f saatchi-console-01 -L 8948:$SAATCHI_GREENSQL_HOST:3306 -N && \
    export MYSQL_PWD=$SAATCHI_GREENSQL_PASSWORD && \
    mycli -h127.0.0.1 -P8948 -u$SAATCHI_GREENSQL_USERNAME -D$SAATCHI_GREENSQL_DB --prompt 'Saatchi[GREENSQL]> ' --auto-vertical-output --warn"
#}}}
#}}}

# saatchi mysql commands {{{
# enable and disable logging all queries to file
LOG_OFF_SQL="SET GLOBAL general_log = 'OFF';"
# create this file first and chmod +w it
SQL_LOG_FILE="/var/log/mysql/saatchi.log"
LOG_ON_SQL="SET GLOBAL general_log_file='$SQL_LOG_FILE'; SET GLOBAL general_log = 'ON';"
alias saatchi-mysql-saatchi-log-on-local="mysql -h$SAATCHI_LOCAL_HOST -u$SAATCHI_LOCAL_USERNAME --execute=\"$LOG_ON_SQL\" && echo 'query logging enabled at $SQL_LOG_FILE'"
alias saatchi-mysql-saatchi-log-off-local="mysql -h$SAATCHI_LOCAL_HOST -u$SAATCHI_LOCAL_USERNAME --execute=\"$LOG_OFF_SQL\" && echo 'query logging disabled'"

# create this file first and chmod +w it
SQL_LOG_FILE="/var/log/mysql/zed.log"
LOG_ON_SQL="SET GLOBAL general_log_file='$SQL_LOG_FILE'; SET GLOBAL general_log = 'ON';"
alias saatchi-mysql-zed-log-on-local="touch $SQL_LOG_FILE && mysql -h$ZED_LOCAL_HOST -u$ZED_LOCAL_USERNAME --execute=\"$LOG_ON_SQL\" && echo 'query logging enabled at $SQL_LOG_FILE'"
alias saatchi-mysql-zed-log-off-local="mysql -h$ZED_LOCAL_HOST -u$ZED_LOCAL_USERNAME --execute=\"$LOG_OFF_SQL\" && echo 'query logging disabled'"
# }}}

# saatchi - retrieve key names for common cache keys {{{
function saatchi-memcached-art-key () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-memcached-art-key {user_id} {art_id}"; return; fi; echo "Saatchi_Model_Base_User_Art-$2-$1"; }
function saatchi-memcached-user-key () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-memcached-user-key {user_id}"; return; fi; echo "Saatchi_Model_Base_User-$1"; }
function saatchi-memcached-acl-key () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-memcached-acl-key {user_id}"; return; fi; echo "Saatchi_Model_Base_User_Acl_Roles_$1"; }
# }}}

# saatchi latest deployed versions {{{
# colorize release output
BLACK="[1;30m"
RED="[1;31m"
GREEN="[1;32m"
YELLOW="[1;33m"
BLUE="[1;34m"
PINK="[1;35m"
CYAN="[1;36m"
WHITE="[1;37m"
NORMAL="[1;0m"
function _saatchi-release-color () {
    # awk version
    # echo "$1" | awk -F' ' '{print $1" ""\033[34m"$2"\033[0m"" "$3" ""\033[32m"$4"\033[0m"" "$5" "$6" "$7" ""\033[33m"$8"\033[0m"" "$9" ""\033[35m"$10"\033[0m";}'
    # sed version
    echo "$1" | sed -E -e "s/^Branch ([a-zA-Z0-9\.\/\-]+) \(at ([0-9a-z]{7})[0-9a-z\)]+ deployed as release ([0-9]{4})([0-9]{2})([0-9]{2})([0-9]{2})([0-9]{2})[0-9]{2} by ([a-z\.]+).*/${BLUE}\1 ${RED}\2${NORMAL} deployed by ${GREEN}\8${NORMAL} on ${YELLOW}\3-\4-\5${NORMAL} at ${PINK}\6:\7${NORMAL} UTC/"
}
alias saatchi-release-legacy-xqa='_saatchi-release-color "$(ssh saatchi-xqa-legacy-01 tail -n 1 /data/code_base/revisions.log)"'
alias saatchi-release-legacy-xdev='_saatchi-release-color "$(ssh saatchi-xdev-legacy-01 tail -n 1 /data/code_base/revisions.log)"'
alias saatchi-release-legacy-xprod='_saatchi-release-color "$(ssh saatchi-xprod-legacy-01 tail -n 1 /data/code_base/revisions.log)"'

alias saatchi-release-gallery-xqa='_saatchi-release-color "$(ssh saatchi-xqa-gallery-01 tail -n 1 /data/gallery/revisions.log)"'
alias saatchi-release-gallery-xdev='_saatchi-release-color "$(ssh saatchi-xdev-gallery-01 tail -n 1 /data/gallery/revisions.log)"'
alias saatchi-release-gallery-xprod='_saatchi-release-color "$(ssh saatchi-xprod-gallery-01 tail -n 1 /data/gallery/revisions.log)"'

alias saatchi-release-easel-xqa='_saatchi-release-color "$(ssh saatchi-xqa-gallery-01 tail -n 1 /data/easel/revisions.log)"'
alias saatchi-release-easel-xdev='_saatchi-release-color "$(ssh saatchi-xdev-gallery-01 tail -n 1 /data/easel/revisions.log)"'
alias saatchi-release-easel-xprod='_saatchi-release-color "$(ssh saatchi-xprod-gallery-01 tail -n 1 /data/easel/revisions.log)"'

alias saatchi-release-palette-xqa='_saatchi-release-color "$(ssh saatchi-xqa-palette-01 tail -n 1 /data/palette/revisions.log)"'
alias saatchi-release-palette-xdev='_saatchi-release-color "$(ssh saatchi-xdev-palette-01 tail -n 1 /data/palette/revisions.log)"'
alias saatchi-release-palette-xprod='_saatchi-release-color "$(ssh saatchi-xprod-palette-01 tail -n 1 /data/palette/revisions.log)"'

alias saatchi-release-zed-xqa='_saatchi-release-color "$(ssh saatchi-xqa-zed-01 tail -n 1 /data/shop/revisions.log)"'
alias saatchi-release-zed-xdev='_saatchi-release-color "$(ssh saatchi-xdev-zed-01 tail -n 1 /data/shop/revisions.log)"'
alias saatchi-release-zed-xprod='_saatchi-release-color "$(ssh saatchi-xprod-zed-01 tail -n 1 /data/shop/revisions.log)"'

alias saatchi-release-catalog-xqa='_saatchi-release-color "$(ssh saatchi-xqa-catalog-01 tail -n 1 /data/catalog/revisions.log)"'
alias saatchi-release-catalog-xdev='_saatchi-release-color "$(ssh saatchi-xdev-catalog-01 tail -n 1 /data/catalog/revisions.log)"'
alias saatchi-release-catalog-xprod='_saatchi-release-color "$(ssh saatchi-xprod-catalog-01 tail -n 1 /data/catalog/revisions.log)"'

alias saatchi-release-api-xqa='_saatchi-release-color "$(ssh saatchi-xqa-catalog-01 tail -n 1 /data/api/revisions.log)"'
alias saatchi-release-api-xdev='_saatchi-release-color "$(ssh saatchi-xdev-catalog-01 tail -n 1 /data/api/revisions.log)"'
alias saatchi-release-api-xprod='_saatchi-release-color "$(ssh saatchi-xprod-catalog-01 tail -n 1 /data/api/revisions.log)"'

alias saatchi-release-imgproc-xqa='_saatchi-release-color "$(ssh saatchi-xqa-origin-01 tail -n 1 /data/imgproc/revisions.log)"'
alias saatchi-release-imgproc-xdev='_saatchi-release-color "$(ssh saatchi-xdev-origin-01 tail -n 1 /data/imgproc/revisions.log)"'
alias saatchi-release-imgproc-xprod='_saatchi-release-color "$(ssh saatchi-xprod-origin-01 tail -n 1 /data/imgproc/revisions.log)"'

function saatchi-releases-xdev () {
    out="\n"
    out+="Legacy: $(saatchi-release-legacy-xdev)\n"
    out+="Gallery: $(saatchi-release-gallery-xdev)\n"
    out+="Easel: $(saatchi-release-easel-xdev)\n"
    out+="Palette: $(saatchi-release-palette-xdev)\n"
    out+="Zed: $(saatchi-release-zed-xdev)\n"
    out+="Catalog: $(saatchi-release-catalog-xdev)\n"
    out+="Api: $(saatchi-release-api-xdev)\n"
    out+="Imgproc: $(saatchi-release-imgproc-xdev)\n"
    echo $out | column -t -s' '
}

function saatchi-releases-xqa () {
    out="\n"
    out+="Legacy: $(saatchi-release-legacy-xqa)\n"
    out+="Gallery: $(saatchi-release-gallery-xqa)\n"
    out+="Easel: $(saatchi-release-easel-xqa)\n"
    out+="Palette: $(saatchi-release-palette-xqa)\n"
    out+="Zed: $(saatchi-release-zed-xqa)\n"
    out+="Catalog: $(saatchi-release-catalog-xqa)\n"
    out+="Api: $(saatchi-release-api-xqa)\n"
    out+="Imgproc: $(saatchi-release-imgproc-xqa)\n"
    echo $out | column -t -s' '
}

function saatchi-releases-xprod () {
    out="\n"
    out+="Legacy: $(saatchi-release-legacy-xprod)\n"
    out+="Gallery: $(saatchi-release-gallery-xprod)\n"
    out+="Easel: $(saatchi-release-easel-xprod)\n"
    out+="Palette: $(saatchi-release-palette-xprod)\n"
    out+="Zed: $(saatchi-release-zed-xprod)\n"
    out+="Catalog: $(saatchi-release-catalog-xprod)\n"
    out+="Api: $(saatchi-release-api-xprod)\n"
    out+="Imgproc: $(saatchi-release-imgproc-xprod)\n"
    echo $out | column -t -s' '
}
# }}}

# saatchi crontab {{{
# alias saatchi-cron-legacy-services-01="ssh saatchi-xprod-legacy-services-01 -t 'sudo -u www-data crontab -l'" # not needed currently
alias saatchi-cron-legacy-services-xqa="ssh appdeploy@saatchi-xqa-legacy-services-01 'sudo -u www-data crontab -l' | rougify -l ini | less -r"
alias saatchi-cron-legacy-services-xdev="ssh appdeploy@saatchi-xdev-legacy-services-01 'sudo -u www-data crontab -l' | rougify -l ini | less -r"
alias saatchi-cron-legacy-services-xprod="ssh appdeploy@saatchi-xprod-legacy-services-02 'sudo -u www-data crontab -l' | rougify -l ini | less -r"
# alias saatchi-cron-legacy-services-02="ssh appdeploy@saatchi-xprod-legacy-services-02 -t 'sudo -u www-data VISUAL=vim crontab -e'" # this one edits
# }}}

# saatchi docker shells {{{
# add any args to run commands in the instances
function saatchi-docker-legacy-nginx () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_legacy_nginx_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_legacy_nginx_instance env TERM=xterm bash -il; }
function saatchi-docker-legacy-fpm () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_legacy_fpm_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_legacy_fpm_instance env TERM=xterm bash -il; }
function saatchi-docker-legacy-gotifier () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_legacy_gotifier_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_legacy_gotifier_instance env TERM=xterm bash -il; }
function saatchi-docker-legacy-memcached () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_legacy_session_memcached_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_legacy_session_memcached_instance env TERM=xterm sh -il; }

function saatchi-docker-zed-nginx () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_zed_nginx_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_zed_nginx_instance env TERM=xterm bash -il; }
function saatchi-docker-zed-fpm () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_zed_fpm_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_zed_fpm_instance env TERM=xterm bash -il; }
function saatchi-docker-zed-memcached () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_zed_memcached_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_zed_memcached_instance env TERM=xterm sh -il; }

function saatchi-docker-palette-nginx () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_palette_nginx_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_palette_nginx_instance env TERM=xterm bash -il; }
function saatchi-docker-palette-fpm () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_palette_fpm_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_palette_fpm_instance env TERM=xterm bash -il; }

function saatchi-docker-gallery-nginx () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_gallery_nginx_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_gallery_nginx_instance env TERM=xterm bash -il; }
function saatchi-docker-gallery-fpm () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_gallery_fpm_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_gallery_fpm_instance env TERM=xterm bash -il; }
function saatchi-docker-gallery-redis () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_gallery_session_redis_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_gallery_session_redis_instance env TERM=xterm sh -il; }
function saatchi-docker-gallery-memcached () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_gallery_cache_memcached_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_gallery_cache_memcached_instance env TERM=xterm sh -il; }

function saatchi-docker-easel-node () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_easel_node_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_easel_node_instance env TERM=xterm bash -il; }

function saatchi-docker-couchbase () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_couchbase_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_couchbase_instance env TERM=xterm bash -il; }

function saatchi-docker-catalog-unicorn () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_catalog_unicorn_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_catalog_unicorn_instance env TERM=xterm bash -il; }
function saatchi-docker-catalog-sidekiq () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_catalog_sidekiq_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_catalog_sidekiq_instance env TERM=xterm bash -il; }
function saatchi-docker-catalog-redis () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_catalog_redis_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_catalog_redis_instance env TERM=xterm sh -il; }

function saatchi-docker-api-unicorn () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_api_unicorn_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_api_unicorn_instance env TERM=xterm bash -il; }

function saatchi-docker-lb () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_lb_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_lb_instance env TERM=xterm bash -il; }

function saatchi-docker-imgproc-node () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_imgproc_node_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_imgproc_node_instance env TERM=xterm bash -il; }
function saatchi-docker-imgproc-redis () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_imgproc_redis_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_imgproc_redis_instance env TERM=xterm sh -il; }

function saatchi-docker-mysql () { if [[ $# > 0 ]]; then; dme && docker exec -t xsaatchi_mysql_instance "$@"; return; fi; dme && docker exec -ti xsaatchi_mysql_instance env TERM=xterm sh -il; }
# }}}

# saatchi docker command shortcuts {{{
function sde () { dme && _docker_exec $SAATCHI_DOCKER_CONTAINER $@; }
function sdv () { dme && _docker_exec $SAATCHI_DOCKER_CONTAINER vendor/bin/$@; }
function sda () { dme && _docker_exec $SAATCHI_DOCKER_CONTAINER php artisan $@; }
# }}}

# run saatchi legacy scripts (commands) {{{
function saatchi-command-legacy-local() {if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-command-legacy-local art/my-script --my-arg=1"; return; fi; saatchi-docker-legacy-fpm php -dxdebug.remote_autostart=1 -dxdebug.remote_connect_back=1 -dxdebug.idekey=${XDEBUG_IDE_KEY} -dxdebug.remote_port=9000 -ddisplay_errors=on /data/code_base/current/scripts/$1.php local -v ${@:2}; }
function saatchi-command-legacy-xdev() {if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-command-legacy-xdev art/my-script --my-arg=1"; return; fi; autossh -t saatchi-xdev-legacy-services-01 "php -ddisplay_errors=on /data/code_base/current/scripts/$1.php development -v ${@:2}"; }
function saatchi-command-legacy-xqa() {if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-command-legacy-xqa art/my-script --my-arg=1"; return; fi; autossh -t saatchi-xqa-legacy-services-01 "php -ddisplay_errors=on /data/code_base/current/scripts/$1.php qa -v ${@:2}"; }
function saatchi-command-legacy-xprod() {if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-command-legacy-xprod art/my-script --my-arg=1"; return; fi; autossh -t saatchi-xprod-legacy-services-02 "php -ddisplay_errors=on /data/code_base/current/scripts/$1.php production -v ${@:2}"; }
# }}}

# saatchi docker attach to log output {{{
alias saatchi-attach-legacy-nginx="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/legacy && docker-compose logs --follow legacy.nginx; cd -"
alias saatchi-attach-legacy-fpm="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/legacy && docker-compose logs --follow legacy.fpm; cd -"
alias saatchi-attach-legacy-gotifier="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/legacy && docker-compose logs --follow legacy.gotifier; cd -"
alias saatchi-attach-legacy-memcached="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/legacy && docker-compose logs --follow legacy.session.memcached; cd -"

alias saatchi-attach-zed-fpm="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/zed && docker-compose logs --follow zed.fpm; cd -"
alias saatchi-attach-zed-nginx="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/zed && docker-compose logs --follow zed.nginx; cd -"
alias saatchi-attach-zed-memcached="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/zed && docker-compose logs --follow zed.session.memcached; cd -"

alias saatchi-attach-palette-nginx="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/palette && docker-compose logs --follow palette.nginx; cd -"
alias saatchi-attach-palette-fpm="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/palette && docker-compose logs --follow palette.fpm; cd -"

alias saatchi-attach-gallery-nginx="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/gallery && docker-compose logs --follow gallery.nginx; cd -"
alias saatchi-attach-gallery-fpm="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/gallery && docker-compose logs --follow gallery.fpm; cd -"
alias saatchi-attach-gallery-redis="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/gallery && docker-compose logs --follow gallery.redis; cd -"
alias saatchi-attach-gallery-memcached="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/gallery && docker-compose logs --follow gallery.session.memcached; cd -"

alias saatchi-attach-easel-node="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/easel && docker-compose logs --follow easel.node; cd -"

alias saatchi-attach-couchbase="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/couchbase && docker-compose logs --follow couchbase.db; cd -"

alias saatchi-attach-catalog-unicorn="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/catalog && docker-compose logs --follow catalog.unicorn; cd -"
alias saatchi-attach-catalog-sidekiq="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/catalog && docker-compose logs --follow catalog.sidekiq; cd -"
alias saatchi-attach-catalog-redis="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/catalog && docker-compose logs --follow catalog.redis; cd -"

alias saatchi-attach-api-unicorn="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/api && docker-compose logs --follow api.unicorn; cd -"

alias saatchi-attach-lb="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/lb && docker-compose logs --follow lb; cd -"

alias saatchi-attach-imgproc-node="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/imgproc && docker-compose logs --follow imgproc.node; cd -"
alias saatchi-attach-imgproc-redis="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/imgproc && docker-compose logs --follow imgproc.redis; cd -"

alias saatchi-attach-mysql="export COMPOSE_HTTP_TIMEOUT=99999 && dme && cd $XDOCKER_DIR/apps/mysql && docker-compose logs --follow mysql.db; cd -"
# }}}

# saatchi fire sns event {{{
function saatchi-sns-art-uploaded-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-sns-art-uploaded-xdev {user_id} {art_id}"; return; fi; aws sns publish --topic-arn $SAATCHI_XDEV_ARN_ART_UPDATED --message "{\"user_id\":$1,\"art_id\":$2,\"timestamp\":\"2017-07-31T22:11:25+00:00\",\"event\":\"art:uploaded\",\"type\":\"uploaded\"}" --profile=east; }
function saatchi-sns-art-uploaded-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-sns-art-uploaded-xqa {user_id} {art_id}"; return; fi; aws sns publish --topic-arn $SAATCHI_XQA_ARN_ART_UPDATED --message "{\"user_id\":$1,\"art_id\":$2,\"timestamp\":\"2017-07-31T22:11:25+00:00\",\"event\":\"art:uploaded\",\"type\":\"uploaded\"}" --profile=east; }
function saatchi-sns-art-uploaded-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-sns-art-uploaded-xprod {user_id} {art_id}"; return; fi; aws sns publish --topic-arn $SAATCHI_XPROD_ARN_ART_UPDATED --message "{\"user_id\":$1,\"art_id\":$2,\"timestamp\":\"2017-07-31T22:11:25+00:00\",\"event\":\"art:uploaded\",\"type\":\"uploaded\"}" --profile=west; }

function saatchi-sns-collection-updated-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-sns-collection-updated-xdev {user_id} {id_user_collection}"; return; fi; aws sns publish --topic-arn $SAATCHI_XDEV_ARN_COLLECTION_UPDATED --message "{\"timestamp\":\"2016-09-19T20:52:18+00:00\",\"event\":\"collection_updated\",\"actor\":\"$1\",\"id_user_collection\":\"$2\"}" --profile=east; }
function saatchi-sns-collection-updated-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-sns-collection-updated-xqa {user_id} {id_user_collection}"; return; fi; aws sns publish --topic-arn $SAATCHI_XQA_ARN_COLLECTION_UPDATED --message "{\"timestamp\":\"2016-09-19T20:52:18+00:00\",\"event\":\"collection_updated\",\"actor\":\"$1\",\"id_user_collection\":\"$2\"}" --profile=east; }
function saatchi-sns-collection-updated-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-sns-collection-updated-xprod {user_id} {id_user_collection}"; return; fi; aws sns publish --topic-arn $SAATCHI_XPROD_ARN_COLLECTION_UPDATED --message "{\"timestamp\":\"2016-09-19T20:52:18+00:00\",\"event\":\"collection_updated\",\"actor\":\"$1\",\"id_user_collection\":\"$2\"}" --profile=west; }
# art updated requires more than is feasible for a function.

# }}}

# saatchi couchbase {{{
tmp_file="/tmp/tmp.json"

# Get a local document {{{
#
# e.g. saatchi-couchbase-local-get catalog user_badges
# buckets are: art, catalog, collection, user
#
_saatchi-couchbase-get-local () {
    if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-local-get {bucket} {my_key}"; return; fi;
    cbc cat "$2" -U "$SAATCHI_LOCAL_COUCHBASE/$1" | python -m json.tool | rougify -l javascript -t tulip | less -R;
}
saatchi-couchbase-get-art-local () { _saatchi-couchbase-get-local art $@; }
saatchi-couchbase-get-catalog-local () { _saatchi-couchbase-get-local catalog $@; }
saatchi-couchbase-get-collection-local () { _saatchi-couchbase-get-local collection $@; }
saatchi-couchbase-get-user-local () { _saatchi-couchbase-get-local user $@; }
# xdev, etc. will not work this way because only accessible via socks proxy.
# I tried ssh port forwarding but I got "administratively prohibited".

# Internal method to view a couchbase doc through the services box
_saatchi-couchbase-get () {
    BUCKET=$1
    KEY=$2
    COUCHBASE_SERVER=$3
    ENVIRO=$4
    SERVICES=$5

    SSH_COMMAND="php -r \"\\\$result = (new CouchbaseCluster('$COUCHBASE_SERVER'))->openBucket('$BUCKET')->get('$KEY')->value; echo is_string(\\\$result) ? \\\$result : json_encode(\\\$result, JSON_PRETTY_PRINT);\""
    RESULT=$(ssh $SERVICES "$SSH_COMMAND")
    echo "$RESULT" | python -m json.tool | rougify -l javascript | less -R
}
saatchi-couchbase-get-catalog-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-catalog-xdev {key}"; return; fi; _saatchi-couchbase-get "catalog" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01"; }
saatchi-couchbase-get-catalog-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-catalog-xqa {key}"; return; fi; _saatchi-couchbase-get "catalog" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xdev" "saatchi-xqa-legacy-services-01"; }
saatchi-couchbase-get-catalog-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-catalog-xprod {key}"; return; fi; _saatchi-couchbase-get "catalog" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xdev" "saatchi-xprod-legacy-services-02"; }

saatchi-couchbase-get-art-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-art-xdev {key}"; return; fi; _saatchi-couchbase-get "art" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01"; }
saatchi-couchbase-get-art-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-art-xqa {key}"; return; fi; _saatchi-couchbase-get "art" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xdev" "saatchi-xqa-legacy-services-01"; }
saatchi-couchbase-get-art-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-art-xprod {key}"; return; fi; _saatchi-couchbase-get "art" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xdev" "saatchi-xprod-legacy-services-02"; }

saatchi-couchbase-get-user-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-user-xdev {key}"; return; fi; _saatchi-couchbase-get "user" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01"; }
saatchi-couchbase-get-user-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-user-xqa {key}"; return; fi; _saatchi-couchbase-get "user" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xdev" "saatchi-xqa-legacy-services-01"; }
saatchi-couchbase-get-user-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-user-xprod {key}"; return; fi; _saatchi-couchbase-get "user" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xdev" "saatchi-xprod-legacy-services-02"; }

saatchi-couchbase-get-collection-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-collection-xdev {key}"; return; fi; _saatchi-couchbase-get "collection" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01"; }
saatchi-couchbase-get-collection-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-collection-xqa {key}"; return; fi; _saatchi-couchbase-get "collection" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xdev" "saatchi-xqa-legacy-services-01"; }
saatchi-couchbase-get-collection-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-get-collection-xprod {key}"; return; fi; _saatchi-couchbase-get "collection" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xdev" "saatchi-xprod-legacy-services-02"; }
# }}}

# Query a couchbase view {{{
#
# e.g. saatchi-couchbase-local-view catalog toaf art_fairs \&key=\"toaf_art_fair\"
#
saatchi-couchbase-view-local () {
    if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-local-view {bucket} {design_doc} {view_name} {params}"; return; fi;
    cbc view -U "$SAATCHI_LOCAL_COUCHBASE/$1" $2/$3 --with-docs --params="?connection_timeout=60000&stale=false$4";
}
# }}}

# Create couchbase doc: Open an editor. On save and quit create the doc with supplied key. {{{
#
saatchi-couchbase-create-local () {
    if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-local-create {bucket} {my_key}"; return; fi;
    echo '' > "$tmp_file"
    vim "$tmp_file"
    if [ -s "$tmp_file" ]; then
        cat "$tmp_file" | cbc create "$2" -U "$SAATCHI_LOCAL_COUCHBASE/$1"
        rm "$tmp_file"
    else
        echo "no data to insert"
    fi
}
# }}}

# Update couchbase doc: Open an editor. On save and quit update the doc with supplied key. {{{
#
# e.g. saatchi-couchbase-update-local catalog test123123
#
_saatchi-couchbase-update-local () {
    BUCKET=$1
    KEY=$2
    cbc cat "$KEY" -U "$SAATCHI_LOCAL_COUCHBASE/$BUCKET" | python -m json.tool > $tmp_file
    if [ -s "$tmp_file" ]; then
        vim "$tmp_file"
        cat "$tmp_file" | cbc create "$KEY" -U "$SAATCHI_LOCAL_COUCHBASE/$BUCKET"
        rm "$tmp_file"
        echo "done"
    else
        echo "no data for this key"
    fi
}
saatchi-couchbase-update-art-local () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-art-local {my_key}"; return; fi; _saatchi-couchbase-update-local "art" $1; }
saatchi-couchbase-update-catalog-local () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-catalog-local {my_key}"; return; fi; _saatchi-couchbase-update-local "catalog" $1; }
saatchi-couchbase-update-collection-local () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-collection-local {my_key}"; return; fi; _saatchi-couchbase-update-local "collection" $1; }
saatchi-couchbase-update-user-local () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-user-local {my_key}"; return; fi; _saatchi-couchbase-update-local "user" $1; }

# Internal method to update a couchbase doc on a server through the services box
_saatchi-couchbase-update () {
    BUCKET=$1
    KEY=$2
    COUCHBASE_SERVER=$3
    ENVIRO=$4
    SERVICES=$5
    # echo "$BUCKET $KEY $COUCHBASE_SERVER $ENVIRO $SERVICES"

    # set up the php
    CB_TMP_FILE="/tmp/couchbase-$BUCKET-$KEY.json"
    SSH_COMMAND="php -r \"\\\$result = (new CouchbaseCluster('$COUCHBASE_SERVER'))->openBucket('$BUCKET')->get('$KEY')->value; file_put_contents('$CB_TMP_FILE', is_string(\\\$result) ? json_encode(json_decode(\\\$result), JSON_PRETTY_PRINT) : json_encode(\\\$result, JSON_PRETTY_PRINT));\""

    if ! ssh $SERVICES "$SSH_COMMAND"; then
        echo 'Document Not Found'
        return
    fi
    # copy the file down and edit it
    scp $SERVICES:$CB_TMP_FILE $CB_TMP_FILE
    vim "$CB_TMP_FILE"
    # if the file is not empty, scp it up, insert it into couchbase
    if [ -s "$CB_TMP_FILE" ]; then
        scp $CB_TMP_FILE $SERVICES:$CB_TMP_FILE
        rm "$CB_TMP_FILE"
        SSH_COMMAND="php -r \"(new CouchbaseCluster('$COUCHBASE_SERVER'))->openBucket('$BUCKET')->upsert('$KEY', json_decode(file_get_contents('$CB_TMP_FILE'), true));\" && rm $CB_TMP_FILE"
        ssh $SERVICES "$SSH_COMMAND"
        echo "done"
    else
        echo "no data to insert"
    fi
}
saatchi-couchbase-update-art-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-art-xdev {bucket} {key}"; return; fi; _saatchi-couchbase-update "art" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01" }
saatchi-couchbase-update-catalog-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-catalog-xdev {bucket} {key}"; return; fi; _saatchi-couchbase-update "catalog" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01" }
saatchi-couchbase-update-collection-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-collection-xdev {bucket} {key}"; return; fi; _saatchi-couchbase-update "collection" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01" }
saatchi-couchbase-update-user-xdev () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-user-xdev {bucket} {key}"; return; fi; _saatchi-couchbase-update "user" "$1" "$SAATCHI_XDEV_COUCHBASE_SERVER" "xdev" "saatchi-xdev-legacy-services-01" }

saatchi-couchbase-update-art-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-art-xqa {bucket} {key}"; return; fi; _saatchi-couchbase-update "art" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xqa" "saatchi-xqa-legacy-services-01" }
saatchi-couchbase-update-catalog-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-catalog-xqa {bucket} {key}"; return; fi; _saatchi-couchbase-update "catalog" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xqa" "saatchi-xqa-legacy-services-01" }
saatchi-couchbase-update-collection-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-collection-xqa {bucket} {key}"; return; fi; _saatchi-couchbase-update "collection" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xqa" "saatchi-xqa-legacy-services-01" }
saatchi-couchbase-update-user-xqa () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-user-xqa {bucket} {key}"; return; fi; _saatchi-couchbase-update "user" "$1" "$SAATCHI_XQA_COUCHBASE_SERVER" "xqa" "saatchi-xqa-legacy-services-01" }

saatchi-couchbase-update-art-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-art-xprod {bucket} {key}"; return; fi; _saatchi-couchbase-update "art" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xprod" "saatchi-xprod-legacy-services-02" }
saatchi-couchbase-update-catalog-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-catalog-xprod {bucket} {key}"; return; fi; _saatchi-couchbase-update "catalog" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xprod" "saatchi-xprod-legacy-services-02" }
saatchi-couchbase-update-collection-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-collection-xprod {bucket} {key}"; return; fi; _saatchi-couchbase-update "collection" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xprod" "saatchi-xprod-legacy-services-02" }
saatchi-couchbase-update-user-xprod () { if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-couchbase-update-user-xprod {bucket} {key}"; return; fi; _saatchi-couchbase-update "user" "$1" "$SAATCHI_XPROD_COUCHBASE_SERVER" "xprod" "saatchi-xprod-legacy-services-02" }
# }}}
# }}}

# saatchi solr {{{

# uses httpie to query solr {{{
saatchi-solr-query-art-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-art-local q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_LOCAL_SOLR/solr/ap_art/select wt==json $@ -j | less -R; }
saatchi-solr-query-art-xdev () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-art-xdev q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_XDEV_SOLR:8080/solr/ap_art/select wt==json $@ -j | less -R; }
saatchi-solr-query-art-xqa () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-art-xqa q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_XQA_SOLR:8080/solr/ap_art/select wt==json $@ -j | less -R; }
saatchi-solr-query-art-xprod () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-art-xprod q==\"*:*\" sort==\"random asc\" ..."; return; fi; ssh -f saatchi-console-01 -L 8397:$SAATCHI_XPROD_SOLR:8080 -N && http --pretty=all http://localhost:8397/solr/ap_art/select wt==json $@ -j | less -R; }
# }}}

# query collections in solr {{{
saatchi-solr-query-collection-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-collection-local q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_LOCAL_SOLR/solr/ap_collection/select wt==json $@ -j | less -R; }
saatchi-solr-query-collection-xdev () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-collection-xdev q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_XDEV_SOLR:8080/solr/ap_collection/select wt==json $@ -j | less -R; }
saatchi-solr-query-collection-xqa () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-collection-xqa q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_XQA_SOLR:8080/solr/ap_collection/select wt==json $@ -j | less -R; }
saatchi-solr-query-collection-xprod () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-collection-xprod q==\"*:*\" sort==\"random asc\" ..."; return; fi; ssh -f saatchi-console-01 -L 8397:$SAATCHI_XPROD_SOLR:8080 -N && http --pretty=all http://localhost:8397/solr/ap_collection/select wt==json $@ -j | less -R; }
# }}}

# query users in solr {{{
saatchi-solr-query-user-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-user-local q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_LOCAL_SOLR/solr/ap/select wt==json $@ -j | less -R; }
saatchi-solr-query-user-xdev () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-user-xdev q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_XDEV_SOLR:8080/solr/ap/select wt==json $@ -j | less -R; }
saatchi-solr-query-user-xqa () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-user-xqa q==\"*:*\" sort==\"random asc\" ..."; return; fi; http --pretty=all $SAATCHI_XQA_SOLR:8080/solr/ap/select wt==json $@ -j | less -R; }
saatchi-solr-query-user-xprod () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-query-user-xprod q==\"*:*\" sort==\"random asc\" ..."; return; fi; ssh -f saatchi-console-01 -L 8397:$SAATCHI_XPROD_SOLR:8080 -N && http --pretty=all http://localhost:8397/solr/ap/select wt==json $@ -j | less -R; }
# }}}

# index artwork in solr by id_user_art {{{
saatchi-solr-index-art-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-local {id_user_art}"; return; fi; dme && docker exec -ti xsaatchi_legacy_fpm_instance php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-id.php local -v -minId=$1 -maxId=$1; }
saatchi-solr-index-art-xdev () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-xdev {id_user_art}"; return; fi; ssh saatchi-xdev-legacy-services-01 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-id.php development -v -minId=$1 -maxId=$1;" }
saatchi-solr-index-art-xqa () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-xqa {id_user_art}"; return; fi; ssh saatchi-xqa-legacy-services-01 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-id.php qa -v -minId=$1 -maxId=$1;" }
saatchi-solr-index-art-xprod () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-xprod {id_user_art}"; return; fi; ssh saatchi-xprod-legacy-services-02 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-id.php production -v -minId=$1 -maxId=$1;" }
# }}}

# index art by artist id {{{
saatchi-solr-index-art-by-artist-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-local {id_user_art}"; return; fi; dme && docker exec -ti xsaatchi_legacy_fpm_instance php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-artist-id.php local -v --artist-id=$1; }
saatchi-solr-index-art-by-artist-xdev () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-xdev {id_user_art}"; return; fi; ssh saatchi-xdev-legacy-services-01 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-artist-id.php development -v --artist-id=$1;" }
saatchi-solr-index-art-by-artist-xqa () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-xqa {id_user_art}"; return; fi; ssh saatchi-xqa-legacy-services-01 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-artist-id.php qa -v --artist-id=$1;" }
saatchi-solr-index-art-by-artist-xprod () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-art-xprod {id_user_art}"; return; fi; ssh saatchi-xprod-legacy-services-02 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-art-by-artist-id.php production -v --artist-id=$1;" }
# }}}

# index collections by user id {{{
saatchi-solr-index-collections-by-user-id-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-collections-by-user-id-local {user_id}"; return; fi; dme && docker exec -ti xsaatchi_legacy_fpm_instance php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-collection-data.php local -v -minId=$1 -maxId=$1; }
saatchi-solr-index-collections-by-user-id-xdev () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-collections-by-user-id-xdev {user_id}"; return; fi; ssh saatchi-xdev-legacy-services-01 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-collection-data.php development -v -minId=$1 -maxId=$1;" }
saatchi-solr-index-collections-by-user-id-xqa () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-collections-by-user-id-xqa {user_id}"; return; fi; ssh saatchi-xqa-legacy-services-01 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-collection-data.php qa -v -minId=$1 -maxId=$1;" }
saatchi-solr-index-collections-by-user-id-xprod () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-index-collections-by-user-id-xprod {user_id}"; return; fi; ssh saatchi-xprod-legacy-services-02 -t "php -ddisplay_errors=on /data/code_base/current/scripts/solr/index-collection-data.php production -v -minId=$1 -maxId=$1;" }
# }}}

# delete solr docs by query {{{
saatchi-solr-delete-docs-by-query-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-solr-delete-docs-by-query-local {query_in_quotes}"; return; fi; noglob curl $SAATCHI_LOCAL_SOLR:8983/solr/ap_art/update?commit=true -H "Content-Type: text/xml" --data-binary "<delete><query>$1</query></delete>" }
# }}}

# add art to collection {{{
saatchi-add-artwork-to-collection-internal () {
    saatchisc_cookie=$1
    collection_id=$2
    artist_id=$3
    artwork_id=$4
    this_env=$5
    base_url=$6
    cookie_name=$7
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-add-artwork-to-collection-$2 {saatchisc[env]_cookie} {collection_id} {artist_id} {artwork_id}"; return; fi;
    http $base_url/collections/add-art/owner/$artist_id/id/$artwork_id/collection/$collection_id  X-Requested-With:XMLHttpRequest Cookie:$cookie_name=$saatchisc_cookie
}
saatchi-add-artwork-to-collection-local () { saatchi-add-artwork-to-collection-internal $1 $2 $3 $4 'local' 'http://www.local.saatchiart.com' 'saatchisclocal' }
saatchi-add-artwork-to-collection-xdev () { saatchi-add-artwork-to-collection-internal $1 $2 $3 $4 'xdev' 'https://www.xdev.saatchiart.com' 'saatchiscdevelopment' }
saatchi-add-artwork-to-collection-xqa () { saatchi-add-artwork-to-collection-internal $1 $2 $3 $4 'xqa' 'https://www.xqa.saatchiart.com' 'saatchiscqa' }
saatchi-add-artwork-to-collection-xprod () { saatchi-add-artwork-to-collection-internal $1 $2 $3 $4 'xprod' 'https://www.saatchiart.com' 'saatchisc' }
# }}}

# }}}

# saatchi local-scripts {{{

# Lauren's "matchback" files - order items in a csv with details. {{{
#
saatchi-matchback () {
    if [[ "$1" == "--help" ]]; then echo "Usage: saatchi-matchback --date-from=2017-01-20 --date-to=2017-02-01 --only-country=USA --with-category"; return; fi;
    autossh mike.funk@saatchi-xprod-legacy-services-02 -t "cd local-scripts && ( [ -f output.csv ] && rm output.csv ); ./bin/app order-items-to-csv $@" && \
        scp mike.funk@saatchi-xprod-legacy-services-02:local-scripts/output.csv $HOME/output.csv && \
        wc -l $HOME/output.csv && \
        open $HOME && \
        osascript -e 'tell application "System Events" to key code 123 using control down'
    # ^ ctrl-left to go to the finder space
}
# }}}

# }}}

# saatchi docker {{{

saatchi-docker-start () {
    dme
    wd xdocker
    ./start_all
    builtin cd -
}
alias saatchi-docker-restart="saatchi-docker-start"

saatchi-docker-stop () {
    eval $(docker-machine env)
    wd xdocker
    ./stop_all
    builtin cd -
}

## }}}

# saatchi - flatten items (from mysql to couchbase) by pk {{{
saatchi-flatten-user-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-user-local {user_id}"; return; fi;
    dme && docker exec -ti xsaatchi_catalog_unicorn_instance bash -c "source /etc/profile && export SAATCHI_ENV=local && export RAILS_ENV=local && cd /data/catalog/current && export REDIS_URL=redis://catalog.redis && rake flatten:user[$1]"
}

saatchi-flatten-artwork-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-artwork-local {id_user_art}"; return; fi;
    dme && docker exec -ti xsaatchi_catalog_unicorn_instance bash -c "source /etc/profile && export SAATCHI_ENV=local && export RAILS_ENV=local && cd /data/catalog/current && export REDIS_URL=redis://catalog.redis && rake flatten:artwork[$1]"
}
# super verbose rails console method
# saatchi-flatten-art-for-user-local () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-art-for-user-local {user_id}"; return; fi; dme && docker exec -ti saatchi_catalog_instance bash -c "source /etc/profile && export SAATCHI_ENV=local && export RAILS_ENV=local && cd /data/catalog/current && export REDIS_URL=redis://redis:6379/0 && ( echo 'User.find($1).artworks.each {|art| art.flatten}' | bin/rails c )" }
saatchi-flatten-art-for-user-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-art-for-user-local {user_id}"; return; fi;
    dme && docker exec -ti xsaatchi_catalog_unicorn_instance bash -c "source /etc/profile && export SAATCHI_ENV=local && export RAILS_ENV=local && cd /data/catalog/current && export REDIS_URL=redis://catalog.redis && bin/rails runner 'User.find($1).artworks.each {|art| art.flatten}' && echo 'done'"
}

saatchi-flatten-collection-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-collection-local {id_user_collection}"; return; fi;
    dme && docker exec -ti xsaatchi_catalog_unicorn_instance bash -c "source /etc/profile && export SAATCHI_ENV=local && export RAILS_ENV=local && cd /data/catalog/current && export REDIS_URL=redis://catalog.redis && rake flatten:collection[$1]"
}

saatchi-flatten-user-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-user-xdev {user_id}"; return; fi;
        ssh appdeploy@saatchi-xdev-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=development && export RAILS_ENV=development && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XDEV_REDIS_SERVER && rake flatten:user[$1]\""
}

saatchi-flatten-artwork-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-artwork-xdev {id_user_art}"; return; fi;
    ssh appdeploy@saatchi-xdev-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=development && export RAILS_ENV=development && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XDEV_REDIS_SERVER && rake flatten:artwork[$1]\""
}

saatchi-flatten-art-for-user-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-art-for-user-xdev {user_id}"; return; fi;
    ssh appdeploy@saatchi-xdev-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=development && export RAILS_ENV=development && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XDEV_REDIS_SERVER && bin/rails runner 'User.find($1).artworks.each {|art| art.flatten}' && echo 'done'\""
}

saatchi-flatten-collection-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-collection-xdev {id_user_collection}"; return; fi;
    ssh appdeploy@saatchi-xdev-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=development && export RAILS_ENV=development && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XDEV_REDIS_SERVER && rake flatten:collection[$1]\""
}

saatchi-flatten-user-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-user-xqa {user_id}"; return; fi;
    ssh appdeploy@saatchi-xqa-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=qa && export RAILS_ENV=qa && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XQA_REDIS_SERVER && rake flatten:user[$1]\""
}

saatchi-flatten-artwork-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-artwork-xqa {id_user_art}"; return; fi;
    ssh appdeploy@saatchi-xqa-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=qa && export RAILS_ENV=qa && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XQA_REDIS_SERVER && rake flatten:artwork[$1]\""
}

saatchi-flatten-art-for-user-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-art-for-user-xqa {user_id}"; return; fi;
    ssh appdeploy@saatchi-xqa-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=qa && export RAILS_ENV=qa && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XQA_REDIS_SERVER && bin/rails runner 'User.find($1).artworks.each {|art| art.flatten}' && echo 'done'\""
}

saatchi-flatten-collection-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-collection-xqa {id_user_collection}"; return; fi;
    ssh appdeploy@saatchi-xqa-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=qa && export RAILS_ENV=qa && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XQA_REDIS_SERVER && rake flatten:collection[$1]\""
}

saatchi-flatten-user-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-user-xprod {user_id}"; return; fi;
    ssh appdeploy@saatchi-xprod-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=production && export RAILS_ENV=production && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XPROD_REDIS_SERVER && rake flatten:user[$1]\""
}

saatchi-flatten-artwork-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-artwork-xprod {id_user_art}"; return; fi;
    ssh appdeploy@saatchi-xprod-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=production && export RAILS_ENV=production && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XPROD_REDIS_SERVER && rake flatten:artwork[$1]\""
}

saatchi-flatten-art-for-user-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-art-for-user-xprod {user_id}"; return; fi;
    ssh appdeploy@saatchi-xprod-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=production && export RAILS_ENV=production && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XPROD_REDIS_SERVER && bin/rails runner 'User.find($1).artworks.each {|art| art.flatten}' && echo 'done'\""
}

saatchi-flatten-collection-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-flatten-collection-xprod {id_user_collection}"; return; fi;
    ssh appdeploy@saatchi-xprod-catalog-01 -t "bash -c \"source /etc/profile && export SAATCHI_ENV=production && export RAILS_ENV=production && cd /data/catalog/current && export REDIS_URL=$SAATCHI_XPROD_REDIS_SERVER && rake flatten:collection[$1]\""
}
# }}}

# saatchi memcached {{{
# Internal methods. from here @link https://gist.github.com/goodevilgenius/11375877 {{{
#
# modified to ssh first
#
_mc_sendmsg() { ssh $MCPROXYSERVER "echo -e \"$*\r\" | nc $MCSERVER $MCPORT;"}
_mc_doset() {
    command="$1"
    shift
    key="$1"
    shift
    let exptime="$1"
    shift
    val="$*"
    let bytes=$(echo -n "$val"|wc -c)
    _mc_sendmsg "$command $key 0 $exptime $bytes\r\n$val"
}
_mc_get() { _mc_sendmsg "get $1" | awk "/^VALUE $1/{a=1;next}/^END/{a=0}a" ;}
_mc_add() { _mc_doset add "$@";}
_mc_delete() { _mc_sendmsg delete "$*"; }
# }}}

# PROD {{{
function saatchi-memcached-get-xprod() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-get-xprod {key}"; return; fi;
    MCSERVER="$SAATCHI_XPROD_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XPROD_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XPROD_MEMCACHE_PROXY"; _mc_get "$@"
}

function saatchi-memcached-add-xprod() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-add-xprod {key} {value}"; return; fi;
    MCSERVER="$SAATCHI_XPROD_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XPROD_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XPROD_MEMCACHE_PROXY"; _mc_add "$@"
}

function saatchi-memcached-delete-xprod() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-xprod {key}"; return; fi;
    MCSERVER="$SAATCHI_XPROD_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XPROD_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XPROD_MEMCACHE_PROXY"; _mc_delete "$@"
}

function saatchi-memcached-clear-user-cache-xprod() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-clear-user-cache-xprod {user_id}"; return; fi;
    saatchi-memcached-delete-xprod "Saatchi_Model_Base_User-$1"
    saatchi-memcached-delete-xprod "Saatchi_Model_Base_User_Acl_Roles_$1"
}

function saatchi-memcached-delete-art-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-art-xdev {user_id} {art_id}"; return; fi;
    saatchi-memcached-delete-xdev "Saatchi_Model_Base_User_Art-$2-$1";
}

function saatchi-memcached-delete-art-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-art-xqa {user_id} {art_id}"; return; fi;
    saatchi-memcached-delete-xqa "Saatchi_Model_Base_User_Art-$2-$1";
}

function saatchi-memcached-delete-art-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-art-xprod {user_id} {art_id}"; return; fi;
    saatchi-memcached-delete-xprod "Saatchi_Model_Base_User_Art-$2-$1";
}

function saatchi-memcached-delete-user-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-user-xdev {user_id}"; return; fi;
    saatchi-memcached-delete-xdev "Saatchi_Model_Base_User-$1";
}

function saatchi-memcached-delete-user-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-user-xqa {user_id}"; return; fi;
    saatchi-memcached-delete-xqa "Saatchi_Model_Base_User-$1";
}

function saatchi-memcached-delete-user-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-user-xprod {user_id}"; return; fi;
    saatchi-memcached-delete-xprod "Saatchi_Model_Base_User-$1";
}

function saatchi-memcached-delete-acl-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-acl-xdev {user_id}"; return; fi;
    saatchi-memcached-delete-xdev "Saatchi_Model_Base_User_Acl_Roles_$1";
}

function saatchi-memcached-delete-acl-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-acl-xqa {user_id}"; return; fi;
    saatchi-memcached-delete-xqa "Saatchi_Model_Base_User_Acl_Roles_$1";
}

function saatchi-memcached-delete-acl-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-acl-xprod {user_id}"; return; fi;
    saatchi-memcached-delete-xprod "Saatchi_Model_Base_User_Acl_Roles_$1";
}
# }}}

# DEV {{{
function saatchi-memcached-get-xdev() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-get-xdev {key}"; return; fi;
    MCSERVER="$SAATCHI_XDEV_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XDEV_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XDEV_MEMCACHE_PROXY"; _mc_get "$@"
}
function saatchi-memcached-add-xdev() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-add-xdev {key} {value}"; return; fi;
    MCSERVER="$SAATCHI_XDEV_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XDEV_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XDEV_MEMCACHE_PROXY"; _mc_add "$@"
}
function saatchi-memcached-delete-xdev() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-xdev {key}"; return; fi;
    MCSERVER="$SAATCHI_XDEV_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XDEV_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XDEV_MEMCACHE_PROXY"; _mc_delete "$@"
}
function saatchi-memcached-clear-user-cache-xdev() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-clear-user-cache-xdev {user_id}"; return; fi;
    saatchi-memcached-delete-xdev "Saatchi_Model_Base_User-$1"
    saatchi-memcached-delete-xdev "Saatchi_Model_Base_User_Acl_Roles_$1"
}
# }}}

# QA {{{
function saatchi-memcached-get-xqa() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-get-xqa {key}"; return; fi;
    MCSERVER="$SAATCHI_XQA_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XQA_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XQA_MEMCACHE_PROXY"; _mc_get "$@"
}
function saatchi-memcached-add-xqa() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-add-xqa {key} {value}"; return; fi;
    MCSERVER="$SAATCHI_XQA_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XQA_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XQA_MEMCACHE_PROXY"; _mc_add "$@"
}
function saatchi-memcached-delete-xqa() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-delete-xqa {key}"; return; fi;
    MCSERVER="$SAATCHI_XQA_MEMCACHE_SERVER"; MCPORT="$SAATCHI_XQA_MEMCACHE_PORT"; MCPROXYSERVER="$SAATCHI_XQA_MEMCACHE_PROXY"; _mc_delete "$@"
}
function saatchi-memcached-clear-user-cache-xqa() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-memcached-clear-user-cache-xqa {user_id}"; return; fi;
    saatchi-memcached-delete-xqa "Saatchi_Model_Base_User-$1"
    saatchi-memcached-delete-xqa "Saatchi_Model_Base_User_Acl_Roles_$1"
}
# }}}
# }}}

# saatchi deploy {{{
# TODO switch to instana
saatchi-deploy () {
    if [[ "$1" == "--help" ]]; then
        echo "Usage: saatchi-deploy {repo} {branch} {environment}"
        return
    fi
    REPO=$1
    BRANCH=$2
    ENVIRONMENT=$3
    SSH_COMMAND="bash -c \""
    SSH_COMMAND+="cd ~/code/$REPO"
    SSH_COMMAND+=" && git fetch"
    SSH_COMMAND+=" && git fetch --tags"
    SSH_COMMAND+=" && git checkout $BRANCH"
    SSH_COMMAND+=" && git pull -r"
    SSH_COMMAND+=" && source \$(/usr/local/rvm/bin/rvm 2.2.2@cap do rvm env --path)"
    SSH_COMMAND+=" && ( echo '' | /usr/local/rvm/gems/ruby-2.2.2@cap/bin/cap $ENVIRONMENT deploy )"
    # dang gallery and its build folder never gets cleaned out
    SSH_COMMAND+=" && cd ~/code/gallery && rm -rf public/build/*"
    SSH_COMMAND+="\""
    ssh saatchi-builder-01 -t "$SSH_COMMAND"
    _open-new-relic $1 $3
}
# open new relic to the right place if production
function _open-new-relic () {
    REPO=$1
    ENVIRONMENT=$2
    if [[ $REPO == "legacy" && $ENVIRONMENT == "production" ]]; then
        open https://rpm.newrelic.com/accounts/136633/applications/38288628/traced_errors
    fi
    if [[ $REPO == "palette" && $ENVIRONMENT == "production" ]]; then
        open https://rpm.newrelic.com/accounts/136633/applications/38928694/traced_errors
    fi
    if [[ $REPO == "gallery" && $ENVIRONMENT == "production" ]]; then
        open https://rpm.newrelic.com/accounts/136633/applications/38928696/traced_errors
    fi
    if [[ $REPO == "zed" && $ENVIRONMENT == "production" ]]; then
        open https://rpm.newrelic.com/accounts/136633/applications/43011541/traced_errors
    fi
    if [[ $REPO == "catalog" && $ENVIRONMENT == "production" ]]; then
        open https://rpm.newrelic.com/accounts/136633/applications/42721002/traced_errors
    fi
    if [[ $REPO == "api" && $ENVIRONMENT == "production" ]]; then
        open https://rpm.newrelic.com/accounts/136633/applications/42721783/traced_errors
    fi
}
# }}}

# saatchi fix permissions {{{
alias saatchi-fix-permissions-gallery="chmod -R a+w $GALLERY_DIR/storage"
alias saatchi-fix-permissions-palette="chmod -R a+w $PALETTE_DIR/storage"
# }}}

# saatchi scp file {{{
# sometimes I don't want to have to redeploy to test something. Never in production though! :)
saatchi-scp-legacy-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-legacy-xdev {relative_path_to_file}"; return; fi;
    scp $LEGACY_DIR/$1 appdeploy@saatchi-xdev-legacy-01:/data/code_base/current/$1
    scp $LEGACY_DIR/$1 appdeploy@saatchi-xdev-legacy-services-01:/data/code_base/current/$1
}

saatchi-scp-legacy-services-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-legacy-services-xdev {relative_path_to_file}"; return; fi;
    scp $LEGACY_DIR/$1 appdeploy@saatchi-xdev-legacy-services-01:/data/code_base/current/$1
}

saatchi-scp-legacy-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-legacy-xqa {relative_path_to_file}"; return; fi;
    scp $LEGACY_DIR/$1 appdeploy@saatchi-xqa-legacy-01:/data/code_base/current/$1
    scp $LEGACY_DIR/$1 appdeploy@saatchi-xqa-legacy-02:/data/code_base/current/$1
    scp $LEGACY_DIR/$1 appdeploy@saatchi-xqa-legacy-services-01:/data/code_base/current/$1
}

saatchi-scp-legacy-services-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-legacy-services-xqa {relative_path_to_file}"; return; fi;
    scp $LEGACY_DIR/$1 appdeploy@saatchi-xqa-legacy-services-01:/data/code_base/current/$1
}

saatchi-scp-gallery-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-gallery-xdev {relative_path_to_file}"; return; fi;
    scp $GALLERY_DIR/$1 appdeploy@saatchi-xdev-gallery-01:/data/gallery/current/$1
}

saatchi-scp-gallery-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-gallery-xqa {relative_path_to_file}"; return; fi;
    scp $GALLERY_DIR/$1 appdeploy@saatchi-xqa-gallery-01:/data/gallery/current/$1
    scp $GALLERY_DIR/$1 appdeploy@saatchi-xqa-gallery-02:/data/gallery/current/$1
}

saatchi-scp-palette-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-palette-xdev {relative_path_to_file}"; return; fi;
    scp $PALETTE_DIR/$1 appdeploy@saatchi-xdev-palette-01:/data/palette/current/$1
}

saatchi-scp-palette-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-palette-xqa {relative_path_to_file}"; return; fi;
    scp $PALETTE_DIR/$1 appdeploy@saatchi-xqa-palette-01:/data/palette/current/$1
    scp $PALETTE_DIR/$1 appdeploy@saatchi-xqa-palette-02:/data/palette/current/$1
}

saatchi-scp-zed-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-zed-xdev {relative_path_to_file}"; return; fi;
    scp $ZED_DIR/$1 appdeploy@saatchi-xdev-zed-01:/data/shop/current/$1
}

saatchi-scp-zed-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-scp-zed-xqa {relative_path_to_file}"; return; fi;
    scp $ZED_DIR/$1 appdeploy@saatchi-xqa-zed-01:/data/shop/current/$1
}
# }}}

# saatchi post zed art {{{
saatchi-zed-post-art-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-zed-post-art-local {user_id} {art_id}"; return; fi;
    dme && docker exec -ti xsaatchi_legacy_fpm_instance php -ddisplay_errors=on /data/code_base/current/scripts/ops/post-zed-art.php local -user_id=$1 -art_id=$2 -v;
}

saatchi-zed-post-art-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-zed-post-art-xdev {user_id} {art_id}"; return; fi;
    ssh saatchi-xdev-legacy-services-01 "php -ddisplay_errors=on /data/code_base/current/scripts/ops/post-zed-art.php development -user_id=$1 -art_id=$2 -v";
}

saatchi-zed-post-art-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-zed-post-art-xqa {user_id} {art_id}"; return; fi;
    ssh saatchi-xqa-legacy-services-01 "php -ddisplay_errors=on /data/code_base/current/scripts/ops/post-zed-art.php qa -user_id=$1 -art_id=$2 -v";
}
# }}}

# saatchi-routes {{{
alias saatchi-routes-legacy-local="wd legacy && ./bin/saatchi routes | less -R && cd -"
alias saatchi-routes-palette-local="saatchi-docker-fpm-palette php /data/palette/current/artisan route:list"
alias saatchi-routes-gallery-local="saatchi-docker-fpm-gallery php /data/gallery/current/artisan route:list"

alias saatchi-routes-catalog-local="dme && \
docker exec -ti xsaatchi_catalog_sidekiq_instance bash -c '\
source /etc/profile && \
export SAATCHI_ENV=local && \
export RAILS_ENV=local && \
cd /data/catalog/current && \
rake routes'"

alias saatchi-routes-api-local="dme && \
docker exec -ti xsaatchi_api_unicorn_instance bash -c '\
source /etc/profile && \
export SAATCHI_ENV=local && \
export RAILS_ENV=local && \
cd /data/api/current && \
rake routes'"
# }}}

# saatchi-rake-tasks {{{
alias saatchi-rake-tasks-catalog-local="dme && \
docker exec -ti xsaatchi_catalog_unicorn_instance bash -c '\
source /etc/profile && \
export SAATCHI_ENV=local && \
export RAILS_ENV=local && \
cd /data/catalog/current && rake --tasks'"

alias saatchi-rake-tasks-api-local="dme && \
docker exec -ti xsaatchi_api_unicorn_instance bash -c '\
source /etc/profile && \
export SAATCHI_ENV=local && \
export RAILS_ENV=local && \
cd /data/api/current && rake --tasks'"
# }}}

# saatchi phpunit (legacy) {{{
alias saatchi-phpunit="pu --testsuite=unit"
# }}}

# saatchi-composer-fix {{{
# function saatchi-composer-fix () { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-composer-fix {ssh_alias}"; return; fi; scp /usr/local/bin/composer appdeploy@$1:~/composer && ssh -t appdeploy@$1 "sudo cp ~/composer /usr/local/bin/composer"; }
function saatchi-composer-fix () {
    if [[ "$1" == "--help" ]]; then
        echo "usage: saatchi-composer-fix {ssh_alias}"
        return
    fi
    scp /usr/local/bin/composer appdeploy@$1:~/composer && \
        ssh -t appdeploy@$1 "sudo cp ~/composer /usr/local/bin/composer"
}
# }}}

# saatchi-tinker {{{
alias saatchi-tinker-legacy-local="dme && docker exec -ti xsaatchi_legacy_fpm_instance /data/code_base/current/bin/saatchi tinker"
# alias saatchi-tinker-legacy-xdev="ssh -t saatchi-xdev-legacy-services-01 /data/code_base/current/bin/saatchi tinker"
# alias saatchi-tinker-legacy-xqa="ssh -t saatchi-xqa-legacy-services-01 /data/code_base/current/bin/saatchi tinker"
# alias saatchi-tinker-legacy-xprod="ssh -t saatchi-xprod-legacy-services-02 /data/code_base/current/bin/saatchi tinker"

alias saatchi-tinker-gallery-local="dme && docker exec -ti xsaatchi_gallery_fpm_instance /data/gallery/current/artisan tinker"
# alias saatchi-tinker-gallery-xdev="ssh -t saatchi-xdev-gallery-01 php /data/gallery/current/artisan tinker"
# alias saatchi-tinker-gallery-xqa="ssh -t saatchi-xqa-gallery-01 php /data/gallery/current/artisan tinker"
# alias saatchi-tinker-gallery-xprod="ssh -t saatchi-xprod-gallery-02 php /data/gallery/current/artisan tinker"

alias saatchi-tinker-palette-local="dme && docker exec -ti xsaatchi_palette_fpm_instance /data/palette/current/artisan tinker"
# alias saatchi-tinker-palette-xdev="ssh -t saatchi-xdev-palette-01 php /data/palette/current/artisan tinker"
# alias saatchi-tinker-palette-xqa="ssh -t saatchi-xqa-palette-01 php /data/palette/current/artisan tinker"
# alias saatchi-tinker-palette-xprod="ssh -t saatchi-xprod-palette-02 php /data/palette/current/artisan tinker"
# }}}

# regenerate zed factories {{{
alias saatchi-factories-zed-local="noglob curl http://zed.local.saatchiart.com/setup/generator/create-factories?verbose=true | html-to-text"
# }}}

# s3 upload {{{
function saatchi-s3-upload-production () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-s3-upload-production {local_path} {remote_path}"; return; fi;
    aws s3 cp $1 s3://saatchi-general/$2;
}

function saatchi-s3-upload-dev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-s3-upload-production {local_path} {remote_path}"; return; fi;
    aws s3 cp $1 s3://saatchi-general-dev/$2;
}
# }}}

# fix zed product quantities {{{
# updates product quantity to 999 for all products for a user
function saatchi-zed-fix-quantity-local () {
    if [[ "$1" == "--help" ]]; then
        echo "usage: saatchi-fix-quantity-local {user_id}"
        return
    fi
    if [ -z "$1" ]; then; echo "please provide a user id"; return; fi;
    QUERY="UPDATE pac_stock_product psp JOIN pac_catalog_product pcp ON "
    QUERY+="psp.fk_catalog_product = pcp.id_catalog_product SET quantity = 999 "
    QUERY+="WHERE pcp.sku LIKE 'P1-U${1}-%'"
    export MYSQL_PWD=$ZED_LOCAL_PASSWORD && \
        mysql -h $ZED_LOCAL_HOST \
        -u $ZED_LOCAL_USERNAME \
        -D $ZED_LOCAL_DB \
        --port=$ZED_LOCAL_PORT \
        --execute "$QUERY" --batch -N;
}
# }}}

# get all open saatchi pull requests {{{
alias saatchi-pull-requests="gh pr --list --org=saatchiart --all --sort long-running --direction desc"
alias saatchi-pull-requests-me="gh pr --list --org=saatchiart --all --me --sort long-running --direction desc"
# alias saatchi-pull-request="hub pull-request -b develop -"
function saatchi-pull-request() { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-pull-request {github_username_of_assignee}"; return; fi; hub pull-request -b develop -a $1; }
# }}}

# take action on a jira {{{
function saatchi-jira() { if [[ "$1" == "--help" ]]; then echo "usage: saatchi-jira {jira_number_without_SA-}"; return; fi; gh jira SA-$1; }
# }}}

# grep for emails in logs {{{
function saatchi-grep-emails-xprod() {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-grep-emails-xprod {email_address}"; return; fi;
    for i in `seq 1 5`; do
        echo "-------------------------"
        echo "saatchi-xprod-legacy-0$i:"
        ssh -t saatchi-xprod-legacy-0$i grep "To:\ $1" /data/temp/saatchi.log -A2 -B1 --color=always
    done
    echo "-------------------------"
    echo "saatchi-xprod-legacy-services-02"
    ssh -t saatchi-xprod-legacy-services-02 grep "To:\ $1" /data/temp/saatchi.log -A2 -B1 --color=always
}
# }}}

# saatchi algolia {{{
function saatchi-algolia-export-artwork-local () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-algolia-export-artwork-local {id_user_art}"; return; fi;
    saatchi-docker-palette-fpm php /data/palette/current/artisan algolia:export-artwork-to-algolia $1
}
function saatchi-algolia-export-artwork-xdev () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-algolia-export-artwork-xdev {id_user_art}"; return; fi;
    ssh -t appdeploy@saatchi-xdev-palette-services-01 "cd /data/palette/current && php artisan algolia:export-artwork-to-algolia $1"
}
function saatchi-algolia-export-artwork-xqa () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-algolia-export-artwork-xqa {id_user_art}"; return; fi;
    ssh -t appdeploy@saatchi-xqa-palette-services-01 "cd /data/palette/current && php artisan algolia:export-artwork-to-algolia $1"
}
function saatchi-algolia-export-artwork-xprod () {
    if [[ "$1" == "--help" ]]; then echo "usage: saatchi-algolia-export-artwork-xprod {id_user_art}"; return; fi;
    ssh -t appdeploy@saatchi-xprod-palette-services-01 "cd /data/palette/current && php artisan algolia:export-artwork-to-algolia $1"
}
# }}}

# saatchi-pm2-monit {{{
# get a cool dashboard to monitor the pm2 process and the child node processes. Leaks memory - be sure to close when done.
alias saatchi-pm2-monit-xdev="autossh -t saatchi-xdev-easel-01 /usr/local/node/node-default/bin/pm2 monit"
alias saatchi-pm2-monit-xqa="autossh -t saatchi-xqa-easel-01 /usr/local/node/node-default/bin/pm2 monit"
alias saatchi-pm2-monit-xprod="autossh -t saatchi-xprod-easel-01 /usr/local/node/node-default/bin/pm2 monit"
# }}}

# saatchi-haproxy-config {{{
alias saatchi-haproxy-config-xdev="ssh saatchi-xdev-lb-01 -t vim -M /etc/haproxy/haproxy.cfg"
alias saatchi-haproxy-config-xqa="ssh saatchi-xqa-lb-01 -t vim -M /etc/haproxy/haproxy.cfg"
alias saatchi-haproxy-config-xprod="ssh saatchi-xprod-lb-01 -t vim -M /etc/haproxy/haproxy.cfg"
# }}}

# saatchi-standup {{{
# alias standup="builtin cd $HOME/Code/saatchi && git standup"
saatchi-standup () { wd legacy && git standup $@ && builtin cd - > /dev/null; }
alias saatchi-standup-monday="standup -d 3"
# }}}

# zed update propel {{{
# see notes on propel.

# check to see if the current schema is different than the one that would be
# with all migrations run
function saatchi-zed-migrations-diff () {
    noglob http GET zed.local.saatchiart.com/setup/cronjob/propel-command/command/diff?verbose=true --check-status
}

# run any necessary migrations
function saatchi-zed-migrations-run () {
    noglob http GET zed.local.saatchiart.com/setup/cronjob/propel-command/command/migrate?verbose=true --check-status
}

# this generates propel files when you edit the schema like this:
# project/Zed/application/components/Sao/Fulfillment/sao_fulfillment.schema.xml
function saatchi-zed-migrations-create () {
    saatchi-docker-zed-fpm ./propel-gen.sh
}

# }}}
