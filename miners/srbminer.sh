#!/bin/bash


docker_run_srbminer_PRL() {
    set -e;
    local VERSION_TAG="$1";

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./srbminer_${VERSION_TAG}/srbminer_custom_bin \
	    --algorithm-gpu pearlhash \
	    --pool br.pearl.herominers.com:1200 \
	    --wallet prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4+mdl1pprpse62zvnexs6ra6tsuhu5qg2sp8k9qqsun8nlpfqw0uw6e3nkqk997vp \
	    --worker multi-zd01 \
	    --api-enable --api-port 80 \
	    --log-file /miners/srbminer.log
}

docker_run_srbminer_RVN() {
    set -e;
    local VERSION_TAG="$1";

	# docker run -d \
	#   --name pearl-miner \
	#   --restart unless-stopped \
	#   --ipc=host \
	#   --gpus all \
	#   -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	#   pearl-multiminerador:latest \
	#   unbuffer ./srbminer_${VERSION_TAG}/srbminer_custom_bin \
	# 	--algorithm kawpow \
	# 	--pool us-rvn.2miners.com:6060 \
	# 	--wallet bc1qvkd7x227z0urkzzlky8hlgve5j5s4ha9swkaxt \
	# 	--password x \
	#     --worker multi-zd01 \
	#     --api-enable --api-port 80 \
	#     --log-file /miners/srbminer.log


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
	  unbuffer ./srbminer_${VERSION_TAG}/srbminer_custom_bin \
        --disable-cpu \
		--algorithm kawpow \
		--pool br.ravencoin.herominers.com:1140 \
		--wallet bc1qvkd7x227z0urkzzlky8hlgve5j5s4ha9swkaxt \
		--password x \
	    --worker multi-zd01 \
        --send-stales true \
	    --api-enable --api-port 80 \
	    --log-file /miners/srbminer.log

# SRBMiner-MULTI.exe --disable-cpu --algorithm kawpow --pool de.ravencoin.herominers.com:1140 --wallet YOUR_RAVEN_WALLET_ADDRESS.YOUR_WORKER_NAME --send-stales true
# pause
}

docker_run_srbminer() {
    set -e;
    local VERSION_TAG="$1";
    local ALGO="${2:-PRL}";  # Default to PRL if not specified

    if [ "$ALGO" == "PRL" ]; then
        docker_run_srbminer_PRL "$VERSION_TAG";
    elif [ "$ALGO" == "RVN" ]; then
        docker_run_srbminer_RVN "$VERSION_TAG";
    else
        echo "Invalid algorithm specified. Use 'PRL' or 'RVN'."
        exit 1;
    fi
}
