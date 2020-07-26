#!/bin/bash

TOKEN=$(yq r "$HOME"/.circleci/cli.yml token)
# USERNAME=saatchiart
USERNAME=$1
# PROJECT=palette
PROJECT=$2
# BRANCH="feature/user-checkin"
# BRANCH=$3

# PRE_COMMIT_REMOTE_URL is available in env
# I wish there was an easier way to do this, but pre-commit just does not let
# you assign evaluated code to a variable in hooks :(
# e.g. I can't do circleci-notify.sh $(git branch --show-current)
# TODO ask about this in an issue
if [[ "$PROJECT" == 'palette' ]]; then
    CODEBASE_URL="$HOME"/Code/saatchi/palette
elif [[ "$PROJECT" == 'zed' ]]; then
    CODEBASE_URL="$HOME"/Code/saatchi/zed
elif [[ "$PROJECT" == 'gallery' ]]; then
    CODEBASE_URL="$HOME"/Code/saatchi/gallery
elif [[ "$PROJECT" == 'easel' ]]; then
    CODEBASE_URL="$HOME"/Code/saatchi/gallery
elif [[ "$PROJECT" == 'legacy' ]]; then
    CODEBASE_URL="$HOME"/Code/saatchi/legacy
fi

if [[ ! "$CODEBASE_URL" ]]; then
    echo "Unknown codebase $CODEBASE_URL"
    exit 1
fi

pushd .
cd "$CODEBASE_URL" || return
BRANCH=$(git branch --show-current)
popd

function uriencode { jq -nr --arg v "$1" '$v|@uri'; }
BRANCH_ENCODED=$(uriencode "${BRANCH}")
IS_FINISHED=0

function check_result () {
    # echo "http --check-status GET https://circleci.com/api/v1.1/project/github/${USERNAME}/${PROJECT}/tree/${BRANCH_ENCODED}?circle-token=${TOKEN}&limit=1"
    RESULT=$(http --check-status GET "https://circleci.com/api/v1.1/project/github/${USERNAME}/${PROJECT}/tree/${BRANCH_ENCODED}?circle-token=${TOKEN}&limit=1")
    if [[ $? != 0 ]]; then
        echo "Non-200 response code received"
        exit 1
    fi
    FIRST_BUILD=$(echo ${RESULT} | jq '.[0]')
    if [[ "${FIRST_BUILD}" == 'null' ]]; then
        echo "No builds found for this branch"
        IS_FINISHED=1
        return 1
    fi
    STATUS=$(echo ${RESULT} | jq '.[0].status') # e.g. success or failed
    BUILD_URL=$(echo ${RESULT} | jq '.[0].build_url')
    LIFECYCLE=$(echo ${RESULT} | jq '.[0].lifecycle') # e.g. finished
    if [[ "${LIFECYCLE}" == '"finished"' ]]; then
        IS_FINISHED=1
    else
        echo "Lifecycle is not yet finished"
        return
    fi
    if [[ "${STATUS}" == '"success"' ]]; then
        echo "Build success"
        NOTI_NSUSER_SOUNDNAME=glass /usr/local/bin/noti --title "✅ CI: ${PROJECT} ${BRANCH}" --message "${BUILD_URL}"
    elif [[ "${STATUS}" == '"failed"' ]]; then
        echo "Build failed"
        NOTI_NSUSER_SOUNDNAME=ping /usr/local/bin/noti --title "❌ CI: ${PROJECT} ${BRANCH}" --message "${BUILD_URL}"
    fi
}

while [[ "${IS_FINISHED}" == 0 ]]; do
    sleep 30
    check_result
done
