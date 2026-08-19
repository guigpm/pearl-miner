#!/bin/bash
set -e;

VERSION_TAG="$1";
WALLET_CPAY="$2";

. /miners/downloads/fl4shminer.sh;

download_fl4shminer "${VERSION_TAG}";

unbuffer ./fl4shminer_${VERSION_TAG}/fl4shminer \
    --algo cryptix-ox8 \
    --pool "stratum+tcp://stratum.cryptix-network.org:13094" \
    --wallet "${WALLET_CPAY}"
