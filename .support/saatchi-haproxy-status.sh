#!/bin/bash
# vim: set foldmethod=marker:

# Get the status of each saatchi docker container heartbeat from the haproxy dashboard.
#
# I tried to set this up as a bash function in my zshrc but tmux did not have
# access to that, and I didn't want to source it before running it every time.
#
# e.g. L+++S++++

CURRENT_SESSION=$(tmux display-message -p '#S')
timeout 1s docker-machine status 1> /dev/null
# timeout 1s sleep 20
if [[ $? != 0 ]]; then
    # docker-machine is probably hanging for some reason... something with virtualbox I think
    # echo "🐳 x"
    # tmux colors
    # echo "#[fg=red]🐳 ✖#[fg=default]"
    # echo "#[fg=red]🐳 …#[fg=default]"
    echo "#[fg=red]🐳 ⟳#[fg=default]"
    exit 0
fi
DOCKER_STATUS=$(docker-machine status) # docker-machine version

# docker for mac version:
# if [ "$(docker run hello-world)" ]; then
# if [ "$(docker ps -q)" ]; then
#     status="Running"
# else
#     status="Down"
# fi


DOCKER="🐳"
GOOD="#[fg=green]+#[fg=default]"
if [[ $CURRENT_SESSION == 'Work' ]]; then
	if [[ $DOCKER_STATUS == 'Running' ]]; then
		HTML=$(curl --user admin:admin -s 'http://www.local.saatchiart.com/haproxy?stats')
        status="$DOCKER "
        status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*legacy01' >/dev/null) && echo $GOOD || echo "#[fg=red]L#[fg=default]")
        status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*imgproc01' >/dev/null) && echo $GOOD || echo "#[fg=red]I#[fg=default]")
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*couchbase01' >/dev/null) && echo $GOOD || echo "#[fg=red]B#[fg=default]")
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*easel01' >/dev/null) && echo $GOOD || echo "#[fg=red]E#[fg=default]")
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*zed01' >/dev/null) && echo $GOOD || echo "#[fg=red]Z#[fg=default]")
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*palette01' >/dev/null) && echo $GOOD || echo "#[fg=red]P#[fg=default]")
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*gallery01' >/dev/null) && echo $GOOD || echo "#[fg=red]G#[fg=default]")
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*catalog01' >/dev/null) && echo $GOOD || echo "#[fg=red]C#[fg=default]")
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*solr01' >/dev/null) && echo $GOOD || echo "#[fg=red]S#[fg=default]")
		echo "$status"
	else
		echo "$DOCKER #[fg=red]-#[fg=default]"
	fi
else
	[[ $DOCKER_STATUS == 'Running' ]] && echo "$DOCKER #[fg=green]+#[fg=default]" || echo "$DOCKER #[fg=red]-#[fg=default]"
fi
