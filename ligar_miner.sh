#!/bin/bash


echo "=== 1. Aplicando Otimizações na RTX 4090 ==="
# Ativa o modo de persistência do driver
sudo nvidia-smi -pm 1


# Remove o limite customizado e restaura o Power Limit original de fábrica da BIOS
#sudo nvidia-smi -rgc

# Define o limite de consumo para 530W
sudo nvidia-smi -pl 530

# Trava a frequência do núcleo em 2610 MHz
#sudo nvidia-smi --lock-gpu-clocks=2610
sudo nvidia-smi --lock-gpu-clocks=2505

# Trava a frequência do núcleo em 2800 MHz
#sudo nvidia-smi --lock-gpu-clocks=2800

# Trava a frequência do núcleo em 3165 MHz
#sudo nvidia-smi --lock-gpu-clocks=3165

# Remove a trava de frequência do núcleo (Core)
#sudo nvidia-smi --reset-gpu-clocks

# Trava a frequência absoluta da memória em 5001 MHz
sudo nvidia-smi --lock-memory-clocks=5001

# Remove a trava de frequência da memória
#sudo nvidia-smi --reset-memory-clocks


echo "=== 2. Iniciando Pearl Miner no Docker ==="
# Remove o contêiner antigo se ele já existir para evitar erros
docker rm -f pearl-miner 2>/dev/null

cd ~/pearl-miner/

docker build -t pearl-multiminerador .


docker_run_srbminer_3_3_3() {
	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./srbminer_3.3.3/srbminer_custom_bin \
	    --algorithm-gpu pearlhash \
	    --pool br.pearl.herominers.com:1200 \
	    --wallet prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --api-enable --api-port 80 \
	    --log-file /miners/srbminer.log
}

docker_run_srbminer_3_3_5() {
	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./srbminer_3.3.5/srbminer_custom_bin \
	    --algorithm-gpu pearlhash \
	    --pool br.pearl.herominers.com:1200 \
	    --wallet prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --api-enable --api-port 80 \
	    --log-file /miners/srbminer.log
}

docker_run_srbminer_3_3_9() {
	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./srbminer_3.3.9/srbminer_custom_bin \
	    --algorithm-gpu pearlhash \
	    --pool br.pearl.herominers.com:1200 \
	    --wallet prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --api-enable --api-port 80 \
	    --log-file /miners/srbminer.log
}

docker_run_srbminer_3_4_2() {
	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./srbminer_3.4.2/srbminer_custom_bin \
	    --algorithm-gpu pearlhash \
	    --pool br.pearl.herominers.com:1200 \
	    --wallet prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4+mdl1pprpse62zvnexs6ra6tsuhu5qg2sp8k9qqsun8nlpfqw0uw6e3nkqk997vp \
	    --worker multi-zd01 \
	    --api-enable --api-port 80 \
	    --log-file /miners/srbminer.log
}

docker_run_srbminer_3_4_2_alphapool() {
	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./srbminer_3.4.2/srbminer_custom_bin \
	    --algorithm-gpu pearlhash \
	    --pool stratum+tcp://us.alphapool.tech:5566 \
	    --wallet prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --api-enable --api-port 80 \
	    --password x \
	    --log-file /miners/srbminer.log
}

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

docker_run_alpha_miner_1_7_6() {
	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./alpha-miner-1.7.6-beta \
	    --pool stratum+tcp://us1.alphapool.tech:5566 \
	    --failover-pools stratum+tcp://us2.alphapool.tech:5566 \
	    --address prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --password "x;d=524288"
}

docker_run_alpha_miner_1_7_7() {
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
	  unbuffer ./alpha-miner-1.7.7 \
	    --pool stratum+tcp://us1.alphapool.tech:5566 \
	    --failover-pools stratum+tcp://us2.alphapool.tech:5566 \
	    --address prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --password "x;d=524288"
}

docker_run_alpha_miner_latest_in() {
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
	  unbuffer ./alpha-miner-latest \
	    --pool stratum+tcp://us1.alphapool.tech:5566 \
	    --failover-pools stratum+tcp://us2.alphapool.tech:5566 \
	    --address prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --password "x;d=524288"
}

docker_run_alpha_miner_1_7_7_direct() {
	docker pull alphaminetech/pearl-miner:1.7.7

	docker run --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  -e PEARL_ADDRESS=prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	  -e PEARL_POOL_HOST=us1.alphapool.tech,us2.alphapool.tech,eu1.alphapool.tech,ru1.alphapool.tech,eu2.alphapool.tech,sg1.alphapool.tech,in1.alphapool.tech \
	  -e PEARL_POOL_PORT=5566 \
	  -e PEARL_DIFFICULTY=524288 \
	  -e PEARL_WORKER=mattioli-zd01 \
	  alphaminetech/pearl-miner:1.7.7
}

docker_run_alpha_miner_latest() {
	docker pull alphaminetech/pearl-miner:latest

	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  -e PEARL_ADDRESS='prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4' \
	  -e PEARL_WORKER=mattioli-zd01 \
	  -e PEARL_POOL_HOST=us1.alphapool.tech,us2.alphapool.tech,eu1.alphapool.tech,sg1.alphapool.tech \
	  -e PEARL_POOL_PORT=5566 \
	  -e PEARL_DIFFICULTY=524288 \
	  alphaminetech/pearl-miner:latest
}

#docker_run_srbminer_3_3_3
#docker_run_srbminer_3_3_5
#docker_run_srbminer_3_3_9
docker_run_srbminer_3_4_2
#docker_run_srbminer_3_4_2_alphapool # Does it work?
#docker_run_alpha_miner_1_7_6
#docker_run_alpha_miner_1_7_7
#docker_run_alpha_miner_latest_in
#docker_run_alpha_miner_1_7_7_direct
#docker_run_alpha_miner_latest

echo "=== Concluído! O minerador está rodando em segundo plano. ==="

docker logs pearl-miner -f
