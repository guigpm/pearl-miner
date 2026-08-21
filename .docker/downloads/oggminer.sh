#!/bin/bash

#https://github.com/Oggchain/OggPoW-Miner/releases/download/v1.0.0/Oggminer-Linux-CUDA13.2.tar

download_oggminer() {
    set -e;
    local VERSION_TAG="$1";
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./-/g')";
    local LOCAL_FOLDER="./oggminer_${VERSION_TAG}";
    echo ">> Download Oggminer-Linux ${VERSION_TAG} and extract files:";
    wget -qO- "https://github.com/Oggchain/OggPoW-Miner/releases/download/v${VERSION_TAG}/Oggminer-Linux-CUDA13.2.tar" | tar -xvf - -C /miners;
    mv ./Oggminer-Linux-CUDA13.2 ${LOCAL_FOLDER};
    chown -R miners:miners ${LOCAL_FOLDER};
    chmod +x ${LOCAL_FOLDER}/oggminer;
}