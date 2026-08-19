#!/bin/bash


docker_run_fl4shminer() {
    set -e;
    local VERSION_TAG="$1";

	sudo nvidia-smi --lock-gpu-clocks=2505; # CPAY
	sudo nvidia-smi --lock-memory-clocks=5001; # CPAY

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	    /miners/run/fl4shminer.sh "${VERSION_TAG}" "${WALLET_CPAY}"

	# docker run -d \
	#   --name pearl-miner \
	#   --restart unless-stopped \
	#   --ipc=host \
	#   --gpus all \
	#   -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	#   pearl-multiminerador:latest  bash -c "\
	#     . /miners/downloads/fl4shminer.sh; \
	# 	download_fl4shminer \"${VERSION_TAG}\"; \
	# 	unbuffer ./fl4shminer_${VERSION_TAG}/fl4shminer \
	# 		--algo cryptix-ox8 \
	# 		--pool \"stratum+tcp://stratum.cryptix-network.org:13094\" \
	# 		--wallet \"${WALLET_CPAY}\" \
	#   ";

	    #cryptix:qzfsfy9glm4prqlqxas7t7t3ypgat47zkgmedxwltr9xwyhpvp2kgdh8nslge CPAY
	    #cryptix:qqzfpzzzv66vjfyru6r9nfz9lxxkht72t4wdvu4tsfs96r89rumvqf6j3eaae SafeTrade
}
