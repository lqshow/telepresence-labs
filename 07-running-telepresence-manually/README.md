# Overview

集群中可能会因为网络或资源问题，导致 telepresence 启动失败。主要是因为首次启动 Telepresence 需要一段时间，因为集群内的 node 需要下载服务器端的镜像。

我们可以将服务器端的镜像推送到内网 docker register，开发可以在集群内手动运行一个 Telepresence Deployment，从而提升启动速度。

这种方式还取决于开发在本机安装的 telepresence 的版本。

```bash
➜ telepresence --version
0.109
```

## 0.108 使用

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: telepresence-k8s-0-108
  name: telepresence-k8s-0-108
spec:
  replicas: 1
  selector:
    matchLabels:
      app: telepresence-k8s-0-108
  template:
    metadata:
      labels:
        app: telepresence-k8s-0-108
    spec:
      containers:
      - image: datawire/telepresence-k8s:0.108
        name: telepresence-k8s-0-108
EOF
```

然后在本地通过 telepresence 运行指定的 zsh 命令

```bash
# 开发本地只需执行该命令
telepresence --deployment telepresence-k8s-0-108 --run zsh
```

## 0.109 使用

```bash
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: telepresence-k8s-0-109
  name: telepresence-k8s-0-109
spec:
  replicas: 1
  selector:
    matchLabels:
      app: telepresence-k8s-0-109
  template:
    metadata:
      labels:
        app: telepresence-k8s-0-109
    spec:
      containers:
      - image: datawire/telepresence-k8s:0.109
        name: telepresence-k8s-0-109
EOF
```

然后在本地通过 telepresence 运行指定的 zsh 命令

```bash
# 开发本地只需执行该命令
telepresence --deployment telepresence-k8s-0-109 --run zsh
```