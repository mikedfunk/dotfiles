#!/bin/bash

# USAGE:
#
# Ensure you have these tools
# `brew install httpie terminal-notifier jq`
# Ensure you have the env vars defined: JENKINS_URL JENKINS_USER_ID JENKINS_API_TOKEN
#
# Add this to your .git/hooks/pre-push hook:
#
# #!/bin/bash
# "$HOME"/.support/jenkins-notify.sh {JENKINS_PROJECT_NAME} $(git branch --show-current) "$(git log -1 --pretty=%B | head -n1)" &
# disown
# exit 0

PROJECT=$1
BRANCH=$2
COMMIT_MESSAGE=$3

function _uriencode () {
    jq -nr --arg v "$1" '$v|@uri';
}

# yes, jenkins double uriencodes this for some reason
BRANCH_ENCODED=$(_uriencode "$BRANCH")
BRANCH_ENCODED=$(_uriencode "$BRANCH_ENCODED")
IS_FINISHED=0
GET_BUILDS_ATTEMPTS=0
MAX_GET_BUILDS_ATTEMPTS=10

function _notify () {
    TITLE=$1
    MESSAGE=$2
    SOUND=$3
    URL=$4
    COMMAND="terminal-notifier -title '${TITLE}' -subtitle '${MESSAGE}' -message '${COMMIT_MESSAGE}' -sound '${SOUND}' -appIcon 'https://saatchi-jenkins.leaf.io/static/c598813c/images/jenkins.svg'"
    if [[ "$URL" ]]; then
        COMMAND="$COMMAND -open '$URL'"
    fi
    eval "$COMMAND"
}

function _check_result () {
    BUILDS=$(http --check-status GET "$JENKINS_URL"/job/"$PROJECT"/job/"$BRANCH_ENCODED"/api/json --auth "$JENKINS_USER_ID":"$JENKINS_API_TOKEN" 2>/dev/null)

    if [[ $? != 0 ]]; then
        (( GET_BUILDS_ATTEMPTS++ ))

        if (( "$GET_BUILDS_ATTEMPTS" > "$MAX_GET_BUILDS_ATTEMPTS" )); then
            _notify "❌ $PROJECT $BRANCH" "Could not get Jenkins builds after $GET_BUILDS_ATTEMPTS attempts." basso
            IS_FINISHED=1
            return
        fi

        sleep $((60 * 2))
        return
    fi

    BUILD_NUMBER=$(echo "$BUILDS" | jq '.builds[0].number')

    if [[ "$BUILD_NUMBER" == 'null' ]]; then
        _notify "❌ $PROJECT $BRANCH" "No Jenkins builds found for this branch" basso
        IS_FINISHED=1
        return
    fi

    JOB=$(http --check-status GET "$JENKINS_URL"/job/"$PROJECT"/job/"$BRANCH_ENCODED"/"$BUILD_NUMBER"/api/json --auth "$JENKINS_USER_ID":"$JENKINS_API_TOKEN" 2>/dev/null)

    if [[ $? != 0 ]]; then
        _notify "❌ $PROJECT $BRANCH" "Jenkins job API check failed" basso
        IS_FINISHED=1
        return
    fi

    IS_BUILDING=$(echo "$JOB" | jq ".building")

    if [[ "$IS_BUILDING" == 'true' ]]; then
        # echo "still building"
        return
    fi

    IS_FINISHED=1
    JOB_RESULT=$(echo "$JOB" | jq ".result")

    if [[ "$JOB_RESULT" != '"SUCCESS"' ]]; then
        _notify "❌ $PROJECT $BRANCH" "Jenkins build failed: $JOB_RESULT" basso
        return
    fi

    _notify "✅ CI: $PROJECT $BRANCH" "Jenkins build completed" glass "$BUILD_URL"
}

while [[ "$IS_FINISHED" == 0 ]]; do
    sleep 30
    _check_result
done
