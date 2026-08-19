#!/bin/bash

# O alpha-miner disponibiliza o executável direto nas releases do GitHub
# RUN curl -L -o alpha-miner-1.7.7 https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v1.7.7/alpha-miner-1.7.7 && \
#   echo "2cddd2956e11faf4e564d4a901adc13b51137e32bad181eb1c75c8b83eaf27ba  alpha-miner-1.7.7" | sha256sum -c && \
#   chown -R miners:miners ./alpha-miner-1.7.7 && \
#   chmod +x alpha-miner-1.7.7

# REPO_URL="https://github.com/AlphaMine-Tech/alpha-miner/releases"
# REPO_URL="https://github.com/AlphaMine-Tech/alpha-miner/releases/latest"
# API_URL="${REPO_URL/github.com/api.github.com\/repos}"
# JSON_FILE="/tmp/latest_release.json"

# api_download_json_file() {
#     curl -s --request GET --url "$API_URL" --header "Accept: application/vnd.github+json" > "$JSON_FILE"
# }


download_alphaminer() {
    set -e;
    local VERSION_TAG="$1";
    local VERSION_DASH="$(echo "${VERSION_TAG}" | sed 's/\./-/g')";
    echo ">> Download Alpha Miner ${VERSION_TAG} and extract files:";
    curl -L -o "alpha-miner-${VERSION_TAG}" "https://github.com/AlphaMine-Tech/alpha-miner/releases/download/v${VERSION_TAG}/alpha-miner-${VERSION_TAG}";
    chown -R miners:miners "./alpha-miner-${VERSION_TAG}"
    chmod +x "./alpha-miner-${VERSION_TAG}"
}
