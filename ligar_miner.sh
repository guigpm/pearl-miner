#!/bin/bash


echo "=== 1. Aplicando Otimizações na RTX 4090 ==="
# Ativa o modo de persistência do driver
sudo nvidia-smi -pm 1


# Remove o limite customizado e restaura o Power Limit original de fábrica da BIOS
#sudo nvidia-smi -rgc

# Define o limite de consumo para 530W
sudo nvidia-smi -pl 530

# Trava a frequência do núcleo em 2610 MHz
sudo nvidia-smi --lock-gpu-clocks=2610

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

docker_run_alpha_miner_1_7_6() {
	docker run -d \
	  --name pearl-miner \
	  --restart unless-stopped \
	  --ipc=host \
	  --gpus all \
	  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
	  pearl-multiminerador:latest \
	  unbuffer ./alpha-miner-1.7.6-beta \
	    --pool stratum+tcp://us2.alphapool.tech:5566 \
	    --failover-pools stratum+tcp://us1.alphapool.tech:5566 \
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
	  pearl-multiminerador:latest \
	  unbuffer ./alpha-miner-1.7.7 \
	    --pool stratum+tcp://us2.alphapool.tech:5566 \
	    --failover-pools stratum+tcp://us1.alphapool.tech:5566 \
	    --address prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4 \
	    --worker multi-zd01 \
	    --password "x;d=524288"
}

#docker_run_srbminer_3_3_3
#docker_run_srbminer_3_3_5
#docker_run_alpha_miner_1_7_6
docker_run_alpha_miner_1_7_7

# Executa o seu comando exato em segundo plano (-d) com o nome unificado
#docker pull alphaminetech/pearl-miner:latest
#  
#docker run -d \
#  --name pearl-miner \
#  --restart unless-stopped \
#  --ipc=host \
#  --gpus all \
#  -e NVIDIA_DRIVER_CAPABILITIES=compute,utility \
#  -e PEARL_ADDRESS='prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4' \
#  -e PEARL_WORKER=mattioli-zd01 \
#  -e PEARL_POOL_HOST=us2.alphapool.tech \
#  -e PEARL_POOL_PORT=5566 \
#  -e PEARL_DIFFICULTY=524288 \
#  alphaminetech/pearl-miner:latest
  
#echo "=== 2. Iniciando Pearl Miner Local ==="
# 1) Download the miner — source: https://github.com/AlphaMine-Tech/alpha-miner
# Linux x86_64, supports Volta/Ampere/Ada/Hopper/Blackwell auto-detect
# 1. download
#curl -L -o alpha-miner https://github.com/AlphaMine-Tech/alpha-miner/releases/latest/download/alpha-miner
#chmod +x alpha-miner

# 2) verify checksum
#curl -L https://github.com/AlphaMine-Tech/alpha-miner/releases/latest/download/SHA256SUMS \
#  | sha256sum -c

# 3) Replace YOUR_PRL_ADDRESS with your prl1p... wallet address, then run
#./alpha-miner \
#  --pool stratum+tcp://us2.alphapool.tech:5566 \
#  --address 'prl1pkeapkq4t0yudgyxqsmev5tzgrst2w4lspjrsfx2evuxv84zks6vsnfe5v4' \
#  --worker zd01

echo "=== Concluído! O minerador está rodando em segundo plano. ==="

docker logs pearl-miner -f
