
# 将集群中一个已存在的 Deployment 替换为本地的服务

## 场景一

现有 kubernetes 集群我们已经部署了一套完整的 **XDP 服务**，但是其中某个 service 可能出现了问题。按照传统的做法，我们将对应服务可能出现问题的上下文，调整代
码后或者加入一些日志后，重新构建镜像，然后重新做部署进行调试排查。如果再次出现错误异常，我们需要再重复这样的步骤，使人奔溃。

现在我们可以利用 telepresence 将异常的 service 从集群内的流量劫持到本地的进程来进行调试，可以更方便地利用本地熟悉的一些调试工具，或者快速修改代码，加日志来进行排查。

## 场景二

直接绕过自动化流水线（build image & deploy to cluster，这些步骤取决于网络和服务器资源，可能调试一次非常慢）在本地利用 telepresence 实现快速开发调试服务，将远程的 Deployment 代理到本地的进程，直接在本地实现 local + remote 的开发调试模式。

## 常用功能

**使用本地的 zsh 命令，替换远端的服务**

```bash
# 调试模式使用，可随时启动本地映射的端口服务
# 可快速修改代码，启动服务进行调试
telepresence --swap-deployment hello-world \
 --expose 8000 \
 --run zsh
```

**将集群中的 enigma2-datasetx 替换成本地进程，并将流量转发到本地**

```bash
telepresence --swap-deployment enigma2-datasetx \
 --expose 32000 \
 --run ./bin/datasetx
```

**指定容器名称来进行环境交换**

```bash
# 如果 Deploymnet 创建的 Pod 中有多个容器，比如在 istio sidecar 模式下
telepresence --swap-deployment myserver:containername --run-shell
```

## TODO

`--swap-deployment` 的工作原理是会将集群中已存在的 Deployment 的 replicas 设置为 0，将集群中的请求完全转发到本地。

现在我们团队是共享同一个内网测试开发环境的，这种模式的问题就是会对开发环境出现独占模式，感觉并不适合团队内的开发。

alibaba [KT Connect](https://github.com/alibaba/kt-connect) 的 Mesh 模式或许可以解决这个问题，后续有机会尝试下。