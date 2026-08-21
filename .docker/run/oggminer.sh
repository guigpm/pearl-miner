#!/bin/bash
set -e;

VERSION_TAG="$1";
WALLET_OGG="$2";
WORKER_NAME="$3";

. /miners/downloads/oggminer.sh;

download_oggminer "${VERSION_TAG}";

printf "\n\n"

echo "    ██████╗  ██████╗  ██████╗     ███╗   ███╗██╗███╗   ██╗███████╗██████╗ "
echo "    ██╔═══██╗██╔════╝██╔════╝     ████╗ ████║██║████╗  ██║██╔════╝██╔══██╗"
echo "    ██║   ██║██║  ███╗██║  ███╗   ██╔████╔██║██║██╔██╗ ██║█████╗  ██████╔╝"
echo "    ██║   ██║██║   ██║██║   ██║   ██║╚██╔╝██║██║██║╚██╗██║██╔══╝  ██╔══██╗"
echo "    ╚██████╔╝╚██████╔╝╚██████╔╝   ██║ ╚═╝ ██║██║██║ ╚████║███████╗██║  ██║"
echo "     ╚═════╝  ╚═════╝  ╚═════╝    ╚═╝     ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝"

printf "\n"

sleep 1

echo "    ════════════════════════════════════════════════════════════"
echo "              LET THE MINING BEGIN."
echo "    ════════════════════════════════════════════════════════════"

printf "\n"

sleep 2

while true
do
    unbuffer ./oggminer_${VERSION_TAG}/oggminer \
        -U -P stratum1+tcp://${WALLET_OGG}.${WORKER_NAME}@pool.oggcoin.org:8008
    
    printf "\n"
    sleep 2

    echo "    ════════════════════════════════════════════════════════════"
    echo "              Reconnecting..."
    echo "    ════════════════════════════════════════════════════════════"

    printf "\n"
done
