#!/bin/bash


#PING us1.alphapool.tech (15.204.220.54) 56(84) bytes of data.
#64 bytes from ns1020976.ip-15-204-220.us (15.204.220.54): icmp_seq=1 ttl=42 time=172 ms
#
#PING us2.alphapool.tech (15.204.52.113) 56(84) bytes of data.
#64 bytes from ns1018981.ip-15-204-52.us (15.204.52.113): icmp_seq=1 ttl=38 time=231 ms
#
#PING eu1.alphapool.tech (135.125.74.208) 56(84) bytes of data.
#64 bytes from 208.74.125.135.in-addr.arpa (135.125.74.208): icmp_seq=1 ttl=39 time=238 ms
#
#PING ru1.alphapool.tech (193.124.67.157) 56(84) bytes of data.
#64 bytes from v3133778.hosted-by-vdsina.ru (193.124.67.157): icmp_seq=1 ttl=49 time=252 ms
#
#PING eu2.alphapool.tech (57.128.235.75) 56(84) bytes of data.
#64 bytes from 75.235.128.57.in-addr.arpa (57.128.235.75): icmp_seq=1 ttl=38 time=277 ms
#
#PING sg1.alphapool.tech (15.235.212.160) 56(84) bytes of data.
#64 bytes from ns5025896.ip-15-235-212.net (15.235.212.160): icmp_seq=1 ttl=39 time=384 ms
#
#PING in1.alphapool.tech (148.113.49.128) 56(84) bytes of data.
#64 bytes from ns5035923.ip-148-113-49.net (148.113.49.128): icmp_seq=1 ttl=38 time=442 ms


docker_run_alpha_miner() {
    set -e;
    local VERSION_TAG="${1:-latest}";

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  -e PEARL_ADDRESS=prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	  -e PEARL_POOL_HOST=us1.alphapool.tech,us2.alphapool.tech,eu1.alphapool.tech,ru1.alphapool.tech,eu2.alphapool.tech,sg1.alphapool.tech,in1.alphapool.tech \
	  -e PEARL_POOL_PORT=5566 \
	  -e PEARL_DIFFICULTY=524288 \
	  -e PEARL_WORKER=mattioli-zd01 \
	  pearl-multiminerador:latest \
	  unbuffer ./alpha-miner-${VERSION_TAG} \
	    --pool stratum+tcp://us1.alphapool.tech:5566 \
	    --failover-pools stratum+tcp://us2.alphapool.tech:5566 \
	    --address prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --password "x;d=524288;mdl=mdl1pprpse62zvnexs6ra6tsuhu5qg2sp8k9qqsun8nlpfqw0uw6e3nkqk997vp"
}

docker_run_alpha_miner_latest_in() {
	docker_run_alpha_miner "latest"
}


docker_run_alpha_miner_direct() {
    set -e;
    local VERSION_TAG="${1:-latest}";
    
	docker pull alphaminetech/pearl-miner:${VERSION_TAG}

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  -e PEARL_ADDRESS=prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	  -e PEARL_POOL_HOST=us1.alphapool.tech,us2.alphapool.tech,eu1.alphapool.tech,ru1.alphapool.tech,eu2.alphapool.tech,sg1.alphapool.tech,in1.alphapool.tech \
	  -e PEARL_POOL_PORT=5566 \
	  -e PEARL_DIFFICULTY=524288 \
	  -e PEARL_WORKER=mattioli-zd01 \
	  alphaminetech/pearl-miner:${VERSION_TAG}
}

docker_run_alpha_miner_latest() {
	docker_run_alpha_miner_direct "latest";
}
