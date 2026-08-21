#!/bin/bash


docker_run_oggminer() {
    set -e;
    local VERSION_TAG="$1";

	# Hashrate: ±67,5 MH/s
	# Consumo: 410 W

	sudo nvidia-smi --lock-gpu-clocks=2250; # OGG
	sudo nvidia-smi --reset-memory-clocks; # OGG

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	    /miners/run/oggminer.sh "${VERSION_TAG}" "${WALLET_OGG}" "${WORKER_NAME}"
}
