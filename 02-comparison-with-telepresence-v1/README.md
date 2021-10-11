# Comparison with Telepresence v1

## 重构

python -> golang

## 流量管理器

[Telepresence v2](https://www.telepresence.io/) 只有一个全局代理，每个集群上都会有一个全局流量管理器。

另外一个比较大的改进，`Telepresence v1` 在家办公需要通过 VPN 连接公司内网环境的话，是不能断开的，只能修改 method 通过 docker 来启动， `Telepresence v2` 可以直连了。


```bash
➜ kubectl get all -n ambassador
NAME                                  READY   STATUS    RESTARTS   AGE
pod/traffic-manager-c88757b8c-nz4xl   1/1     Running   0          3d11h

NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
service/agent-injector    ClusterIP   10.96.248.160   <none>        443/TCP    97d
service/traffic-manager   ClusterIP   None            <none>        8081/TCP   105d

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/traffic-manager   1/1     1            1           105d

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/traffic-manager-c88757b8c    1         1         1       3d11h
(base)
```

## Telepresence CLI

## 访问方式的变化

[Telepresence v2](https://www.telepresence.io/) 通过 Kubernetes service 的 `服务名称` + `命名空间` + `端口` 访问服务，相比 [Telepresence v1](https://www.telepresence.io/docs/v1/discussion/overview/)，需要额外加上 `namespace`


https://www.telepresence.io/docs/latest/reference/routing/