#!/bin/bash


docker_run_cryptix_miner() {
    set -e;
    local VERSION_TAG="$1";

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./cryptix_miner_${VERSION_TAG}/cryptix-miner \
	    -s "stratum+tcp://stratum.cryptix-network.org:13094" \
	    --mining-address="${WALLET_CPAY}" \
	    -t "14" \
	    --opencl-disable

	    #cryptix:qzfsfy9glm4prqlqxas7t7t3ypgat47zkgmedxwltr9xwyhpvp2kgdh8nslge CPAY
	    #cryptix:qqzfpzzzv66vjfyru6r9nfz9lxxkht72t4wdvu4tsfs96r89rumvqf6j3eaae SafeTrade
}
