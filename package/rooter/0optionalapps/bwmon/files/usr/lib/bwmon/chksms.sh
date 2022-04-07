#!/bin/sh

ROOTER=/usr/lib/rooter
ROOTER_LINK="/tmp/links"

CURRMODEM=1

rm -f /tmp/texting
CPORT=$(uci -q get modem.modem$CURRMODEM.commport)
SMSLOC=$(uci -q get modem.modeminfo$CURRMODEM.smsloc)

if [ -z $CPORT ]; then
	return
fi
OX=$($ROOTER/gcom/gcom-locked "/dev/ttyUSB$CPORT" "smschk.gcom" "$CURRMODEM" "" "$SMSLOC")
ERROR="ERROR"
if `echo ${OX} | grep "${ERROR}" 1>/dev/null 2>&1`
then
	return
fi
echo "0" > /tmp/texting
uci set modem.general.smsnum='1'
uci commit modem
