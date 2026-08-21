# Imagem base do NVIDIA CUDA (baseada em Ubuntu) para garantir suporte a GPU
# FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04
FROM ubuntu:24.04

USER root

# Evita perguntas interativas durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências comuns (CURL, GIT, dependências de vídeo e extração)
RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get install -y \
    expect \
    curl \
    wget \
    git \
    ca-certificates \
    xz-utils \
    libnuma1 \
    libnuma-dev \
    libstdc++6 \
    kmod \
    opencl-c-headers \
    p7zip-full \
    ocl-icd-libopencl1 \
    nvidia-cuda-toolkit \
  && update-ca-certificates \
  && apt-get -y autoremove --purge \
  && apt-get -y clean \
  && rm -rf /var/lib/apt/lists/* \
  && mkdir -p /miners \
  && groupadd -r miners && useradd -r -g miners -d /miners -s /bin/bash miners \
  && chown -R miners:miners /miners

# Diretório onde os mineradores ficarão centralizados
WORKDIR /miners

COPY --chown=miners:miners .docker/downloads /miners/downloads
COPY --chown=miners:miners .docker/run /miners/run

RUN chmod +x /miners/downloads/*.sh \
  && chmod +x /miners/run/*.sh

EXPOSE 80

# Switch to non-root user for security
USER miners

CMD ["/bin/bash"]

