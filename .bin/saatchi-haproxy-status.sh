#!/bin/bash
# Get the status of each saatchi docker container heartbeat from the haproxy dashboard.
#
# I tried to set this up as a bash function in my zshrc but tmux did not have
# access to that, and I didn't want to source it before running it every time.
#
# e.g. L+++S++++
CURRENT_SESSION=$(tmux display-message -p '#S')
status=$(docker-machine status)
DOCKER="🐳"
GOOD="+"
if [[ $CURRENT_SESSION == 'Work' ]]; then
	if [[ $status == 'Running' ]]; then
		HTML=$(curl --user admin:admin -s 'http://local.saatchiart.com/haproxy?stats')
        status="$DOCKER "
        status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*legacy01' >/dev/null) && echo $GOOD || echo 'L')
        status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*imgproc01' >/dev/null) && echo $GOOD || echo 'I')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*couchbase01' >/dev/null) && echo $GOOD || echo 'B')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*easel01' >/dev/null) && echo $GOOD || echo 'E')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*zed01' >/dev/null) && echo $GOOD || echo 'Z')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*palette01' >/dev/null) && echo $GOOD || echo 'P')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*gallery01' >/dev/null) && echo $GOOD || echo 'G')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*catalog01' >/dev/null) && echo $GOOD || echo 'C')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*api01' >/dev/null) && echo $GOOD || echo 'A')
		status+=$( (echo "$HTML" | grep -E '(active_up|active_no_check).*solr01' >/dev/null) && echo $GOOD || echo 'S')
		echo "$status"
	else
		echo "$DOCKER -"
	fi
else
	[[ $status == 'Running' ]] && echo "$DOCKER +" || echo "$DOCKER -"
fi