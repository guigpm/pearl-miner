#!/bin/bash


download_fl4shminer() {
    set -e;
    local VERSION_TAG="$1";
    echo ">> Download Fl4shMiner ${VERSION_TAG} and extract files:";
    wget -qO- "https://github.com/Fl4sh9174/Fl4shMiner/releases/download/${VERSION_TAG}/fl4shminer-${VERSION_TAG}.tar.gz" | tar -xzvf - -C /miners;
    chown -R miners:miners ./fl4shminer;
    chmod +x ./fl4shminer/fl4shminer;
    mv ./fl4shminer "./fl4shminer_${VERSION_TAG}";
}
