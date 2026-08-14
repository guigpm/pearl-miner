#!/bin/bash

GMINER_API_PORT=${API_PORT:-20080}


docker_run_gminer_RVN() {
    set -e;
    local VERSION_TAG="$1";
    local gminer_local_folder="./gminer-${VERSION_TAG}";

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ${gminer_local_folder}/miner \
	    --algo kawpow \
	    --server rvn.2miners.com:6060 \
	    --user "${WALLET_BTC}.${WORKER_NAME}"
}


docker_run_gminer_OGG() {
	# https://nonkyc.io/account/deposit/OGG
	set -e;
	local VERSION_TAG="$1";
	local gminer_local_folder="./gminer-${VERSION_TAG}";

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ${gminer_local_folder}/miner \
	    --algo progpow \
	    --server stratum+tcp://pool.oggcoin.org:8008 \
	    --user "${WALLET_OGG}.${WORKER_NAME}" \
		--pass x \
		--opencl 0 \
		--api ${GMINER_API_PORT}
}

docker_run_gminer() {
    set -e;
    local VERSION_TAG="$1";
    local ALGO="${2:-RVN}";  # Default to RVN if not specified

	if [ "$ALGO" == "RVN" ]; then
		docker_run_gminer_RVN "$VERSION_TAG"
	elif [ "$ALGO" == "OGG" ]; then
		docker_run_gminer_OGG "$VERSION_TAG"
	else
        echo "Invalid algorithm specified. Use 'OGG' or 'RVN'."
        exit 1;
	fi
}
