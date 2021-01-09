## optional arguments

| optional arguments                     | desc                                                         |
| -------------------------------------- | ------------------------------------------------------------ |
| `--new-deployment <DEPLOYMENT_NAME>，或者 -n <DEPLOYMENT_NAME>`   | 新创建一个名为 **DEPLOYMENT_NAME** 的 Deployment(用于本地连接远端集群)       |
| `–swap-deployment <DEPLOYMENT_NAME>，或者 -s <DEPLOYMENT_NAME>` | 替换一个远端集群中已存在的名为 **DEPLOYMENT_NAME** 的 Deployment(用于劫持集群流量到本地)                          |
| `--expose 3000:3000` | 将远端容器 3000 端口的流量转发到本地的 3000 端口 |
| `--run ...`                          | 运行一个指定的命令行参数, e.g. `--run zsh or --run bash or --run $(pwd)/bin/datasetx` |
| `--run-shell`                          | 启动完成后进入一个 local shell 命令行环境，可以继续执行自己需要的服务或命令 |
