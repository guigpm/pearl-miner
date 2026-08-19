#!/bin/bash

SRBMINER_API_PORT=${API_PORT:-20080}

__srbminer_bin() {
	local VERSION_TAG="$1";
	local VERSION_TYPE="${2:-default}";
	if [ "$VERSION_TYPE" == "custom" ]; then
		echo "./srbminer_${VERSION_TAG}_custom/srbminer_custom_bin";
	else
		echo "./srbminer_${VERSION_TAG}/SRBMiner-MULTI";
	fi
}

docker_run_srbminer_PRL() {
    set -e;
    local VERSION_TAG="$1";
	local BIN_RUN=$(__srbminer_bin "$VERSION_TAG" "custom");

	sudo nvidia-smi --lock-gpu-clocks=2610; # PRL
	sudo nvidia-smi --lock-memory-clocks=5001; # PRL

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest bash -c "\
	    . /miners/downloads/srbminer.sh; \
		download_srbminer_custom \"${VERSION_TAG}\"; \
	    unbuffer ${BIN_RUN} \
	      --algorithm-gpu pearlhash \
	      --pool br.pearl.herominers.com:1200 \
	      --wallet \"${WALLET_PRL}+${WALLET_MDL}\" \
	      --worker \"${WORKER_NAME}\" \
	      --api-enable --api-port \"${SRBMINER_API_PORT}\" \
	      --log-file /miners/srbminer.log \
	  ";
}

docker_run_srbminer_RVN() {
    set -e;
    local VERSION_TAG="$1";
	local BIN_RUN=$(__srbminer_bin "$VERSION_TAG" "custom");

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
      -e GPU_MAX_HEAP_SIZE=100	\
      -e GPU_MAX_USE_SYNC_OBJECTS=1	\
      -e GPU_SINGLE_ALLOC_PERCENT=100	\
      -e GPU_MAX_ALLOC_PERCENT=100	\
      -e GPU_MAX_SINGLE_ALLOC_PERCENT=100	\
      -e GPU_ENABLE_LARGE_ALLOCATION=100\
      -e GPU_MAX_WORKGROUP_SIZE=1024 \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ${BIN_RUN} \
        --disable-cpu \
		--algorithm kawpow \
		--pool br.ravencoin.herominers.com:1140 \
		--wallet "${WALLET_BTC}" \
		--password x \
	    --worker "${WORKER_NAME}" \
        --send-stales true \
	    --api-enable --api-port "${SRBMINER_API_PORT}" \
	    --log-file /miners/srbminer.log
}

docker_run_srbminer_OGG() {
    set -e;
    local VERSION_TAG="$1";
	local BIN_RUN=$(__srbminer_bin "$VERSION_TAG" "default");

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ${BIN_RUN} \
	    --disable-cpu \
	    --disable-gpu-opencl \
	    --algorithm-gpu oggpow \
	    --pool stratum+tcp://pool.oggcoin.org:8008 \
	    --wallet "${WALLET_OGG}" \
	    --worker "${WORKER_NAME}" \
	    --api-enable --api-port "${SRBMINER_API_PORT}" \
	    --log-file /miners/srbminer.log
}

docker_run_srbminer() {
    set -e;
    local VERSION_TAG="$1";
    local ALGO="${2:-PRL}";  # Default to PRL if not specified

    if [ "$ALGO" == "PRL" ]; then
        docker_run_srbminer_PRL "$VERSION_TAG";
    elif [ "$ALGO" == "RVN" ]; then
        docker_run_srbminer_RVN "$VERSION_TAG";
	elif [ "$ALGO" == "OGG" ]; then
		docker_run_srbminer_OGG "$VERSION_TAG";
    else
        echo "Invalid algorithm specified. Use 'PRL', 'RVN', or 'OGG'."
        exit 1;
    fi
}

docker_run_srbminer_list_devices() {
	set -e;
	local VERSION_TAG="$1";

	docker run -it --rm \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./srbminer_${VERSION_TAG}_custom/srbminer_custom_bin \
		--list-devices
}
