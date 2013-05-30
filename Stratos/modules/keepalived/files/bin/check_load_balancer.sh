#!/bin/bash

CURL=`which curl`

SERVICE="http://localhost/services/EchoProxy"

RCODE=`${CURL} -sL -w "%{http_code}" "${SERVICE}"`

[ ${RCODE} == '200' ] && exit 0 || exit 1

