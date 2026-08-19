#!/bin/bash


download_cryptix_miner() {
    set -e;
    local VERSION_TAG="$1";
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./-/g')";
    local OS_TYPE="${2:-linux64}";
    local FOLDER_NAME="cryptix-miner-${OS_TYPE}-v-${VERSION_DASH}";
    echo ">> Download cryptix-miner and extract files:";
    curl -L -o /tmp/cryptix-miner.7z "https://github.com/cryptix-network/cryptix-miner/releases/download/v${VERSION_TAG}/${FOLDER_NAME}.7z";
    7z x /tmp/cryptix-miner.7z -o".";
    chown -R miners:miners "./${FOLDER_NAME}";
    chmod +x "./${FOLDER_NAME}/cryptix-miner";
    mv "./${FOLDER_NAME}" "./cryptix_miner_${VERSION_TAG}";
}
