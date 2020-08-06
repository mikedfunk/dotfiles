#!/bin/bash

# USAGE:
#
# Ensure you have these tools
# `brew install circleci httpie terminal-notifier python-yq jq`
# and that you have run `circleci setup` at least once (stores your api credentials)
#
# Add this to your .git/hooks/pre-push hook:
#
# #!/bin/bash
# "$HOME"/.support/circleci-notify.sh {CIRCLECI_USERNAME} {CIRCLECI_PROJECT_NAME} $(git branch --show-current) "$(git log -1 --pretty=%B | head -n1)" &
# disown
# exit 0

TOKEN=$(yq ".token" < "$HOME"/.circleci/cli.yml | tr -d '"')
USERNAME=$1
PROJECT=$2
BRANCH=$3
COMMIT_MESSAGE=$4


function _uriencode () {
    jq -nr --arg v "$1" '$v|@uri';
}

BRANCH_ENCODED=$(_uriencode "$BRANCH")
IS_FINISHED=0

function _notify () {
    TITLE=$1
    MESSAGE=$2
    SOUND=$3
    URL=$4
    COMMAND="terminal-notifier -title '${TITLE}' -subtitle '${MESSAGE}' -message '${COMMIT_MESSAGE}' -sound '${SOUND}' -appIcon 'https://crowdin-static.downloads.crowdin.com/avatar/13528254/medium/23fbef0e445c48537ce85ed21a3fee07.jpg'"
    if [[ "$URL" ]]; then
        COMMAND="$COMMAND -open '$URL'"
    fi
    eval "$COMMAND"
}

function _check_result () {
    RESULT=$(http --check-status GET "https://circleci.com/api/v1.1/project/github/${USERNAME}/${PROJECT}/tree/${BRANCH_ENCODED}?circle-token=${TOKEN}&limit=1" 2>/dev/null)

    if [[ $? != 0 ]]; then
        _notify "❌ CI: $PROJECT $BRANCH" "CircleCI API check failed: $?" basso
        IS_FINISHED=1
        return
    fi

    FIRST_BUILD=$(echo $RESULT | jq '.[0]')

    if [[ "$FIRST_BUILD" == 'null' ]]; then
        _notify "❌ CI: $PROJECT $BRANCH" "No CircleCI builds found for this branch" basso
        IS_FINISHED=1
        return
    fi

    STATUS=$(echo $RESULT | jq '.[0].status') # e.g. success or failed
    BUILD_URL=$(echo $RESULT | jq '.[0].build_url')
    LIFECYCLE=$(echo $RESULT | jq '.[0].lifecycle') # e.g. finished

    if [[ "$LIFECYCLE" != '"finished"' ]]; then
        # echo "Lifecycle is not yet finished"
        return
    fi

    IS_FINISHED=1

    if [[ "$STATUS" != '"success"' ]]; then
        _notify "❌ CI: $PROJECT $BRANCH" "CI failed in CircleCI" basso "$BUILD_URL"
        return
    fi

    _notify "✅ CI: $PROJECT $BRANCH" "CI passed in CircleCI" glass "$BUILD_URL"
}

while [[ "$IS_FINISHED" == 0 ]]; do
    sleep 30
    _check_result
done
