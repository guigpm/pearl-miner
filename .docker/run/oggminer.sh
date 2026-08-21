#!/bin/bash
set -e;

VERSION_TAG="$1";
WALLET_OGG="$2";
WORKER_NAME="$3";

. /miners/downloads/oggminer.sh;

download_oggminer "${VERSION_TAG}";

unbuffer ./oggminer_${VERSION_TAG}/oggminer \
    -U -P stratum1+tcp://${WALLET_OGG}.${WORKER_NAME}@pool.oggcoin.org:8008
