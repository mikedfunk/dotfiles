#!/bin/bash
# Get the status of each saatchi docker container heartbeat from the haproxy dashboard.
#
# I tried to set this up as a bash function in my zshrc but tmux did not have
# access to that, and I didn't want to source it before running it every time.
#
# e.g. L+++S++++
CURRENT_SESSION=$(tmux display-message -p '#S')
if [[ $CURRENT_SESSION == 'Work' ]]; then
    HTML=$(curl --user admin:admin -s 'http://local.saatchiart.com/haproxy?stats')
    GOOD="+"
    status=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="legacy_website_nodes/legacy01"' > /dev/null ) && echo $GOOD || echo 'L'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="assets_nodes/imgproc01"' > /dev/null ) && echo $GOOD || echo 'I'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="couchbase_nodes/couchbase01"' > /dev/null ) && echo $GOOD || echo 'B'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="easel_nodes/easel01"' > /dev/null ) && echo $GOOD || echo 'E'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="zed_nodes/zed01"' > /dev/null ) && echo $GOOD || echo 'Z'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="palette_nodes/palette01"' > /dev/null ) && echo $GOOD || echo 'P'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="gallery_nodes/gallery01"' > /dev/null ) && echo $GOOD || echo 'G'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="catalog_nodes/catalog01"' > /dev/null ) && echo $GOOD || echo 'C'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="api_nodes/api01"' > /dev/null ) && echo $GOOD || echo 'A'`
    status+=`(  echo "$HTML" | grep '"active_up"><td class=ac><a name="solr_nodes/solr01"' > /dev/null ) && echo $GOOD || echo 'S'`
    echo $status
else
    status=$(docker-machine status)
    [[ $status == 'Running' ]] && echo 'd+' || echo 'd-'
fi
