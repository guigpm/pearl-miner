#!/bin/bash


docker_run_gminer() {
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
	    --user bc1qvkd7x227z0urkzzlky8hlgve5j5s4ha9swkaxt.multi-zd01
}
