#!/bin/bash


docker_run_fl4shminer() {
    set -e;
    local VERSION_TAG="$1";

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./fl4shminer_${VERSION_TAG}/fl4shminer \
	    --algo cryptix-ox8 \
	    --pool "stratum+tcp://stratum.cryptix-network.org:13094" \
	    --wallet "${WALLET_CPAY}"

	    #cryptix:qzfsfy9glm4prqlqxas7t7t3ypgat47zkgmedxwltr9xwyhpvp2kgdh8nslge CPAY
	    #cryptix:qqzfpzzzv66vjfyru6r9nfz9lxxkht72t4wdvu4tsfs96r89rumvqf6j3eaae SafeTrade
}
