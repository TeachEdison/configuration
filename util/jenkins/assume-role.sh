#!/usr/bin/env bash

# assume-role function for use by machine services that don't use MFA to assume role.
# source this into your bash script and then
# set +x
# assume-role(${AWS_MFA_ARN})
# set -x
# The function also turns off echoing, but using set +x before calling assume-role
# ensures that your MFA's ARN doesn't leak.

assume-role() {
    set +x
    ROLE_ARN="${1}"
    SESSIONID=$(date +"%s")

    RESULT=(`aws sts assume-role --role-arn $ROLE_ARN \
            --role-session-name $SESSIONID \
            --query '[Credentials.AccessKeyId,Credentials.SecretAccessKey,Credentials.SessionToken]' \
            --output text`)

    export AWS_ACCESS_KEY_ID=${RESULT[0]}
    export AWS_SECRET_ACCESS_KEY=${RESULT[1]}
    export AWS_SECURITY_TOKEN=${RESULT[2]}
    export AWS_SESSION_TOKEN=${AWS_SECURITY_TOKEN}
    set -x
}

