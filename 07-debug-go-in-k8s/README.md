# Overview

Golang 程序官方建议使用 vpn-tcp 模式

## Config File

XDP 平台服务都符合 Cloud Native App 架构模式，是按照 **12-Factor** 方法论构建的，团队内的新人要准备在本地开发环境 Launch application，首先需要拿到一份能够在集群运行的配置文件。


你可以通过以下命令，按需可以从 **Kubernetes 集群** 中将 application 用到的环境变量导入到本地。

```bash
# 导出 json file
telepresence --swap-deployment enigma2-datasetx \
 --expose 32000 \
 --env-json datasetx_env.json
```

```bash
# 导出 .env 文件
telepresence --swap-deployment enigma2-datasetx --env-file .env
```

## Debugging golang application with Telepresence and Goland

我们可以从以上导出的环境变量 json 文件导入到配置中，如下图。

![image](https://user-images.githubusercontent.com/8086910/104332115-cc545b80-552a-11eb-8fcf-a7faa758e353.png)

配置完后，启动报错，如下所示。因为系统 mount 了另外一个 secret 文件。需要手动调整一下环境变量的值方可继续进行

![image](https://user-images.githubusercontent.com/8086910/104334005-ce1f1e80-552c-11eb-9e74-4ad5da9820ca.png)

**manifest**

我们通过查看 manifest ，得知 mount container 的具体 path 如下所示，然后再调整相应数据即可正常运行。

```yaml
...
    volumeMounts:
    - mountPath: /project/xfs-certs/certificate
      name: grpc-cert-pem
      readOnly: true
      subPath: certificate
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: enigma2-datasetx-token-swztv
      readOnly: true
...
```


## Debugging golang application with Telepresence and Docker

不过如果用 docker run 的话，直接使用以下命令即可，将需要的数据挂载到容器内

```bash
telepresence --mount=/tmp/known \
 --swap-deployment enigma2-datasetx \
 --expose 32000 \
 --method container \
 --docker-run \
 -it \
 # 挂载本地源码到 Container 内
 -v $HOME/workspace/basebit/gitlab/enigma2-datasetx:/workspace \
 # 挂载项目用到的 certs 文件
 -v /tmp/known/project:/project \
 lqshow/busybox-curl:1.28 /bin/sh
```
