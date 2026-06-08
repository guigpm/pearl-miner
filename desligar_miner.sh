#!/bin/bash

echo "=== 1. Parando o Minerador no Docker ==="
docker stop pearl-miner

echo "=== 2. Resetando a RTX 4090 para o Padrão de Fábrica ==="
# Remove a trava de frequência do núcleo (Core)
sudo nvidia-smi --reset-gpu-clocks

# Remove a trava de frequência da memória
sudo nvidia-smi --reset-memory-clocks

# Remove o limite customizado e restaura o Power Limit original de fábrica da BIOS
# Captura apenas o número do Power Limit original da BIOS e aplica automaticamente
DEFAULT_PL=$(nvidia-smi -q -d POWER | grep "Default Power Limit" | grep -oE '[0-9]+' | head -n 1)
sudo nvidia-smi -pl $DEFAULT_PL

echo "=== Tudo pronto! GPU liberada para uso comum/jogos ==="

