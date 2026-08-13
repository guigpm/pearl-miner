#!/bin/bash


echo "=== 1. Aplicando Otimizações na RTX 4090 ==="
# Ativa o modo de persistência do driver
sudo nvidia-smi -pm 1


# Remove o limite customizado e restaura o Power Limit original de fábrica da BIOS
#sudo nvidia-smi -rgc

# Define o limite de consumo para 530W
sudo nvidia-smi -pl 530

# Trava a frequência do núcleo em 2610 MHz
#sudo nvidia-smi --lock-gpu-clocks=2610 # PRL
# sudo nvidia-smi --lock-gpu-clocks=2505 # CPAY
sudo nvidia-smi --lock-gpu-clocks=1850 # RVN

# Trava a frequência do núcleo em 2800 MHz
#sudo nvidia-smi --lock-gpu-clocks=2800

# Trava a frequência do núcleo em 3165 MHz
#sudo nvidia-smi --lock-gpu-clocks=3165

# Remove a trava de frequência do núcleo (Core)
#sudo nvidia-smi --reset-gpu-clocks

# Trava a frequência absoluta da memória em 5001 MHz
# sudo nvidia-smi --lock-memory-clocks=5001 # PRL
# sudo nvidia-smi --lock-memory-clocks=5001 # CPAY

sudo nvidia-smi --reset-memory-clocks; # RVN


# Remove a trava de frequência da memória
#sudo nvidia-smi --reset-memory-clocks


echo "=== 2. Build do Docker Image do Minerador ==="
# Remove o contêiner antigo se ele já existir para evitar erros
docker rm -f pearl-miner 2>/dev/null

cd ~/pearl-miner/

#docker build --no-cache -t pearl-multiminerador .
docker build -t pearl-multiminerador .


echo "=== 3. Carregando scripts de mineradores ==="

# Carrega todos os scripts da pasta miners
if [ -d "./miners" ]; then
    for script in ./miners/*.sh; do
        if [ -f "$script" ]; then
            source "$script"
        fi
    done
fi


echo "=== 4. Iniciando o minerador ==="
# Escolha o minerador desejado e a versão correspondente

# docker_run_cryptix_miner "0.2.10"
# docker_run_fl4shminer "v1.2.4"
# docker_run_srbminer "3.5.4" "RVN"
# docker_run_srbminer "3.5.4" "PRL"
# docker_run_alpha_miner "1.7.7"
# docker_run_alpha_miner "latest"
# docker_run_alpha_miner_direct "1.7.7"
# docker_run_alpha_miner_direct "latest"
docker_run_gminer "3.44"

echo "=== Concluído! O minerador está rodando em segundo plano. ==="

docker logs pearl-miner -f
