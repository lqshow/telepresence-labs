# Overview

利用 vscode + container + telepresence 的组合, 将容器用作开发环境。

## Requirements

要使用这个环境，必须在本地机器上安装以下程序

- [Docker](https://docs.docker.com/install/)
- [Visual studio code](https://code.visualstudio.com/)
- [Visual studio code remote development extension pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)

## Configure devcontainer

做配置前，开发者需要清楚明白运行自己应用的必要条件，比如需要暴露什么端口，需要哪些外部文件（通过mount）进来，准备好 `.env` 文件，根据应用的不同，配置都会有所变化

1. 准备一个适合 team 内技术栈的 base image 写入 Dockerfile（可以理解为容器内的开发环境），里面包含了语言环境，kubectl，telepresence（必须）另外开发人员可根据自己习惯打造 shell 环境（可选）
2. 配置 .devcintainer/devcontainer.json文件，用来启动基于 vs code remote container
3. run-devbox.sh 可选文件，我们这里主要用于容器运行后，需要执行的命令语句，比如我们这个案例需要的 telepresence

**以下是配置目录结构**

![image](https://user-images.githubusercontent.com/8086910/117292322-a7ea0980-aea2-11eb-9844-96e066dfd8eb.png)

### devcontainer.json

> 以下对主要配置信息做下说明

```json
{

"runArgs": [
    // 加载应用需要的环境变量
    "--env-file", "${localWorkspaceFolder}/.env",

    "--cap-add=SYS_PTRACE",
    "--cap-add=NET_ADMIN",
    "--cap-add=NET_BIND_SERVICE",
    "--network=host",

    // Uncomment the next line if you will be using a ptrace-based debugger like C++, Go, and Rust.
    "--privileged", "--security-opt", "seccomp=unconfined",

    // 挂载 .ssh 目录，可在容器中直接操作内网 git
    "-v", "${env:HOME}${env:USERPROFILE}/.ssh:/root/.ssh-localhost:ro",
    // 挂载本地的 KUBECONFIG 配置文件到容器内
    "-v", "${env:HOME}${env:USERPROFILE}/.kube:/root/.kube-localhost",
    // 挂载本地的 vscode extensions 到容器，避免在容器中重新安装扩展
    "-v", "${env:HOME}${env:USERPROFILE}/.vscode/extensions:/root/.vscode-server/extensions"
],

"mounts": [
    // 挂载 GOPATH 相关路径，可提升容器内编译速度
    "source=${localEnv:GOPATH}/src,target=/go/src,type=bind,consistency=cached",
    "source=${localEnv:GOPATH}/pkg,target=/go/pkg,type=bind,consistency=cached",
 ],

"containerEnv": {
    // [Optional] 默认将同步开关设置成 true，将本地的 KUBECONFIG 配置文件同步到容器内
    "SYNC_LOCALHOST_KUBECONFIG": "true",
    // Use KUBECONFIG environment variable, if specified
    "KUBECONFIG": "/kube/config",

    // 应用需要集成到 Kubernetes 集群的 namespace
    // 这里采用读取本地环境变量模式，开发只需通过更改本地的环境变量值，而不需要更改 devcontainer.json 配置
    //
    // ```
    // # dev container
    // export KUBERNETES_NAMESPACE=defalut
    // ```
    "KUBERNETES_NAMESPACE": "${localEnv:KUBERNETES_NAMESPACE}",
},

// 在创建容器之前，使用 `initializeCommand` 命令，合并你本机的所有的 KUBE CONFIG 到一个配置文件中（~/.kube/gen-config）
"initializeCommand": [
    "${localWorkspaceFolder}/.devcontainer/export-local-kube-config.sh",
],

// 设置在容器创建完成后运行的命令
// 主要的作用是通过 `telepresence` 与目标 Kubernetes 集群实现互连
"postCreateCommand": [
    "${containerWorkspaceFolder}/.devcontainer/run-devbox.sh"
]
}
```

### Dockerfile

Dockerfile 里的 Base image 是用于在容器化下开发准备的环境，这个镜像各位开发者可以自行定义。

### .env 文件

如果你的项目是一个已经在 kubernetes 集群中运行的应用，如果你本地没有 .env.sample 文件，或者 .env.sample 文件因为多人开发的原因，一直没有好好的维护，可以通过以下命令，从线上直接拉取一份最全的配置到本地进行修改使用。

```bash
telepresence --swap-deployment <online-deployment-name> --env-file .env.online
```

## Usage

1. press: Cmd + shift + p
2. Remote-Containers: Rebuild and Reopen in Container
3. press: enter


执行以上三个步骤后，Container 环境就会启动，第一次可能需要一些时间，取决于您的机器的网络速度，后面基本上都是秒起。

![image](https://user-images.githubusercontent.com/8086910/117294318-14660800-aea5-11eb-843a-6e94f5c7b3a0.png)

**output**

```bash
Running the PostCreateCommand from devcontainer.json...

[4776 ms] Start: Run in container: /workspaces/telepresence-labs/08-vscode-remote-development-with-telepresence/.devcontainer/run-devbox.sh
Context "development-private@xdp-bee" modified.
T: Using a Pod instead of a Deployment for the Telepresence proxy. If you 
T: experience problems, please file an issue!
T: Set the environment variable TELEPRESENCE_USE_DEPLOYMENT to any non-empty 
T: value to force the old behavior, e.g.,
T:     env TELEPRESENCE_USE_DEPLOYMENT=1 telepresence --run curl hello

T: Starting proxy with method 'vpn-tcp', which has the following limitations: 
T: All processes are affected, only one telepresence can run per machine, and 
T: you can't use other VPNs. You may need to add cloud hosts and headless 
T: services with --also-proxy. For a full list of method limitations see 
T: https://telepresence.io/reference/methods.html
T: Volumes are rooted at $TELEPRESENCE_ROOT. See 
T: https://telepresence.io/howto/volumes.html for details.
T: Starting network proxy to cluster using the existing proxy Deployment 
T: telepresence-k8s-0-109

T: No traffic is being forwarded from the remote Deployment to your local 
T: machine. You can use the --expose option to specify which ports you want to 
T: forward.

T: Setup complete. Launching your command.
root ➜ /workspaces/telepresence-labs/08-vscode-remote-development-with-telepresence/.devcontainer (main ✗) $ 
```

## References

- [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)
- [Advanced Container Configuration](https://code.visualstudio.com/docs/remote/containers-advanced)
- [devcontainer.json reference](https://code.visualstudio.com/docs/remote/devcontainerjson-reference)
- [A repository of development container definitions for the VS Code Remote - Containers extension and GitHub Codespaces](https://github.com/microsoft/vscode-dev-containers)
- [Debug containerized apps](https://code.visualstudio.com/docs/containers/debug-common)
- [Use a Docker container as a development environment with Visual Studio Code](https://docs.microsoft.com/en-us/learn/modules/use-docker-container-dev-env-vs-code/)