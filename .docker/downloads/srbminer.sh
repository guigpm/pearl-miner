#!/bin/bash

#  https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/SRBMiner-Multi-${VERSION_DASH}-Linux.tar.gz
#  https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/srbminer_custom-${VERSION_TAG}.tar.gz

download_srbminer_custom() {
    set -e;
    local VERSION_TAG="$1";
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./-/g')";
    echo ">> Download SRBMiner-Multi ${VERSION_TAG} and extract files:";
    wget -qO- "https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/srbminer_custom-${VERSION_TAG}.tar.gz" | tar -xzvf - -C /miners;
    chown -R miners:miners ./srbminer_custom;
    chmod +x ./srbminer_custom/srbminer_custom_bin;
    mv ./srbminer_custom "./srbminer_${VERSION_TAG}_custom";
}

download_srbminer() {
    set -e;
    local VERSION_TAG="$1";
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./-/g')";
    echo ">> Download SRBMiner-Multi ${VERSION_TAG} and extract files:";
    wget -qO- "https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/SRBMiner-Multi-${VERSION_DASH}-Linux.tar.gz" | tar -xzvf - -C /miners;
    chown -R miners:miners "./SRBMiner-Multi-${VERSION_DASH}";
    chmod +x "./SRBMiner-Multi-${VERSION_DASH}/SRBMiner-MULTI";
    mv "./SRBMiner-Multi-${VERSION_DASH}" "./srbminer_${VERSION_TAG}";
}
