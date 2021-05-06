ARG VARIANT=1
FROM mcr.microsoft.com/vscode/devcontainers/go:0-${VARIANT}

# Metadata
LABEL org.label-schema.name="dev-container-go"

# [Optional] Install additional OS packages.
RUN apt-get update \
    && apt-get -y install --no-install-recommends \
    lsb-release \
    iptables \
    iputils-ping \
    dnsutils \
    fonts-powerline \
    kubectx

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

#  [Optional] Use go get to install anything else you need
# RUN go get \
#         github.com/envoyproxy/protoc-gen-validate \
#         github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway \
#         github.com/grpc-ecosystem/grpc-gateway/protoc-gen-swagger \
#         github.com/golang/protobuf/protoc-gen-go \
#         github.com/zmb3/gogetdoc \
#         github.com/ramya-rao-a/go-outline \
#         golang.org/x/tools/gopls

# Install kubectl
# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ARG KUBE_LATEST_VERSION="v1.19.2"
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/bin/kubectl

# Set kubectl config environment variables
ENV KUBECONFIG=/kube/config

# Install helm
# Note: Latest version of helm may be found at
# https://github.com/kubernetes/helm/releases
ARG HELM_VERSION="v3.3.4"
RUN wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm

# Install telepresence
RUN curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | bash
RUN apt install -y --no-install-recommends telepresence

# Script copies localhost's ~/.kube/config file into the container and swaps out
# localhost for host.docker.internal on bash/zsh start to keep them in sync.
COPY copy-kube-config.sh /usr/local/share/
RUN chown ${USERNAME}:root /usr/local/share/copy-kube-config.sh  \
    && echo "source /usr/local/share/copy-kube-config.sh" | tee -a /root/.bashrc >> /root/.zshrc