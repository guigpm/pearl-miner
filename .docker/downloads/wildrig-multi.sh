#!/bin/bash

# https://github.com/andru-kun/wildrig-multi/releases/download/${VERSION_TAG}/wildrig-multi-linux-${VERSION_TAG}.tar.gz

download_wildrig() {
    set -e;
    local VERSION_TAG="$1";
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./-/g')";
    echo ">> Download WildRig Multi ${VERSION_TAG} and extract files:";
    wget -qO- "https://github.com/andru-kun/wildrig-multi/releases/download/${VERSION_TAG}/wildrig-multi-linux-${VERSION_TAG}.tar.gz" | tar -xzvf - -C /miners;
    chown -R miners:miners "./wildrig-multi-linux-${VERSION_TAG}";
    chmod +x "./wildrig-multi-linux-${VERSION_TAG}/wildrig-multi";
    mv "./wildrig-multi-linux-${VERSION_TAG}" "./wildrig_${VERSION_TAG}";
}
