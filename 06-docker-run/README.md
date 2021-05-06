
# Fast development workflow with Docker and Kubernetes

```bash
# 使用 Docker 模式，即便本地拨入其他 vpn 也可正常使用
telepresence --method container \
 --docker-run \
 --rm \
 -it \
 lqshow/busybox-curl:1.28 /bin/sh
```

## 在 Docker 内调试项目

如果你期望开发环境与上生产的运行时环境完全相同，使用 Docker 模式调试项目时，需要使用与生产环境的 Dockefile 来构建的镜像。

```bash
telepresence --method container \
 --docker-run \
 --rm \
 -it \
 -v $(pwd):/workspace \
 lqshow/busybox-curl:1.28 /bin/sh
```

## 一个简单例子

```bash
# 1. 在本机执行 run debug container
➜ make run-debug
[+] Building 17.2s (13/13) FINISHED
 => [internal] load build definition from Dockerfile                                                                                                     0.0s
 => => transferring dockerfile: 37B                                                                                                                      0.0s
 => [internal] load .dockerignore                                                                                                                        0.0s
 => => transferring context: 2B                                                                                                                          0.0s
 => [internal] load metadata for docker.io/library/golang:onbuild                                                                                        3.4s
 => CACHED [1/5] FROM docker.io/library/golang:onbuild@sha256:c0ec19d49014d604e4f62266afd490016b11ceec103f0b7ef44875801ef93f36                           0.0s
 => [internal] load build context                                                                                                                        0.0s
 => => transferring context: 64.76kB                                                                                                                     0.0s
 => [2/5] COPY . /go/src/app                                                                                                                             0.0s
 => [3/5] RUN go-wrapper download                                                                                                                        5.6s
 => [4/5] RUN go-wrapper install                                                                                                                         1.1s
 => [5/5] WORKDIR /data/project                                                                                                                          0.0s  => [6/5] COPY ./ ./                                                                                                                                     0.0s
 => [7/5] RUN go get -d -v                                                                                                                               0.4s
 => [8/5] RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o server .                                                                        6.3s
 => exporting to image                                                                                                                                   0.1s
 => => exporting layers                                                                                                                                  0.1s
 => => writing image sha256:728dec578452c686a1661de243c4c002a67e562a2a7e04609f96fd8cb267e767                                                             0.0s
 => => naming to docker.io/lqshow/docker-run-amd64:9af282f-dirty                                                                                         0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
T: Using a Pod instead of a Deployment for the Telepresence proxy. If you experience problems, please file an issue!
T: Set the environment variable TELEPRESENCE_USE_DEPLOYMENT to any non-empty value to force the old behavior, e.g.,
T:     env TELEPRESENCE_USE_DEPLOYMENT=1 telepresence --run curl hello

T: Volumes are rooted at $TELEPRESENCE_ROOT. See https://telepresence.io/howto/volumes.html for details.
T: Starting network proxy to cluster using the existing proxy Deployment telepresence-k8s-0-109

T: No traffic is being forwarded from the remote Deployment to your local machine. You can use the --expose option to specify which ports you want to
T: forward.

T: Setup complete. Launching your container.
#
```


```bash
# 2. 在容器內编译并执行
# make build
# ./server
```

```bash
# 3. 在本地机器测试验证
➜ curl http://localhost:3000
This service is listening on port 3000
```