#!/bin/sh

set -eu

#Incoming WebHooksURL
WEBHOOKURL="https://hooks.slack.com/services/%MODIFY_YOUR_WEB_HOOK_URL"

# temporal message
MESSAGEFILE=$(mktemp -t webhooksXXXX)
trap "
rm ${MESSAGEFILE}
" 0

usage_exit() {
    echo "Usage: $0 [-m message] [-c channel] [-i icon] [-n botname]" 1>&2
    exit 0
}

while getopts c:i:n:m: opts
do
    case $opts in
        c)
            CHANNEL=$OPTARG
            ;;
        i)
            FACEICON=$OPTARG
            ;;
        n)
            BOTNAME=$OPTARG
            ;;
        m)
            MESSAGE=$OPTARG"\n"
            ;;
        \?)
            usage_exit
            ;;
    esac
done
# send setting
CHANNEL=${CHANNEL:-"%CHANGE_PUSH_CHANNEL_NAME(eg. #general)"}
BOTNAME=${BOTNAME:-"%CHANGE_YOUR_BOTNAME(eg. webhook-bot)"}
FACEICON=${FACEICON:-":passport_control:"}
# title
MESSAGE=${MESSAGE:-""}

if [ -p /dev/stdin ] ; then
    #conv \n for slack
    cat - | tr '\n' '\\' | sed 's/\\/\\n/g'  > ${MESSAGEFILE}
else
    echo "nothing stdin"
    exit 1
fi

WEBMESSAGE='```'`cat ${MESSAGEFILE}`'```'

#send Incoming WebHooks
curl -s -S -X POST --data-urlencode "payload={\"channel\": \"${CHANNEL}\", \"username\": \"${BOTNAME}\", \"icon_emoji\": \"${FACEICON}\", \"text\": \"${MESSAGE}${WEBMESSAGE}\" }" ${WEBHOOKURL} >/dev/null

