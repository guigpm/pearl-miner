#!/bin/bash

# https://github.com/develsoftware/GMinerRelease/releases/download/3.44/gminer_3_44_linux64.tar.xz
download_gminer() {
    set -e;
    local VERSION_TAG="$1";
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./_/g')";
    local OS_TYPE="${2:-linux64}";
    local FOLDER_NAME="gminer_${VERSION_DASH}_${OS_TYPE}";
    local DOWNLOAD_URL="https://github.com/develsoftware/GMinerRelease/releases/download/${VERSION_TAG}/${FOLDER_NAME}.tar.xz";
    echo ">> Download gminer and extract files from ${DOWNLOAD_URL}:";
    curl -L -o /tmp/gminer.tar.xz ${DOWNLOAD_URL};
    local gminer_local_folder="./gminer-${VERSION_TAG}";
    mkdir ${gminer_local_folder};
    tar -xvf /tmp/gminer.tar.xz -C ${gminer_local_folder};
    chown -R miners:miners ${gminer_local_folder};
    chmod +x "${gminer_local_folder}/miner";
}
