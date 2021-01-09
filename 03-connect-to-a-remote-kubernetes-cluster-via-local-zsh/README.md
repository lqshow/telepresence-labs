
## 使用本地 zsh 无缝连接到集群
我们知道本地机器是无法直接使用 kubernetes 集群中的 service 短域名的，比如以下所示。

```bash
# 已知集群中存在 hello-world 服务
➜ kubectl get svc
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
hello-world   ClusterIP   10.99.185.150   <none>        8000/TCP   22h
```

```bash
# 使用 dig 直接查看 kubernetes cluster 的 hello-world，得不到响应
➜ dig hello-world

; <<>> DiG 9.10.6 <<>> hello-world
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 58423
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;hello-world.                   IN      A

;; AUTHORITY SECTION:
.                       1641    IN      SOA     a.root-servers.net. nstld.verisign-grs.com. 2021010500 1800 900 604800 86400

;; Query time: 8 msec
;; SERVER: 192.168.0.1#53(192.168.0.1)
;; WHEN: Tue Jan 05 19:39:18 CST 2021
;; MSG SIZE  rcvd: 115

# 使用 curl 访问异常
➜ curl hello-world:8000
curl: (6) Could not resolve host: hello-world
```

那么我们能不能够在本地开发环境通过熟悉的 zsh，快速和 kubernetes 集群中已有服务打通呢？
```bash
# 1. 通过 telepresence 运行指定的 zsh 命令解决
telepresence --new-deployment local-zsh --run zsh

➜ cat $TELEPRESENCE_ROOT/etc/os-release
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.6.5
PRETTY_NAME="Alpine Linux v3.6"
HOME_URL="http://alpinelinux.org"
BUG_REPORT_URL="http://bugs.alpinelinux.org"

# 2. 再次使用 dig 查看 kubernetes cluster 的 hello-world，能够得到响应。
# 获取到的 IP：10.99.185.150 是 kubernetes 集群中的 svc 的 cluster ip 

➜ dig hello-world

; <<>> DiG 9.10.6 <<>> hello-world
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32776
;; flags: qr aa ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;hello-world.                   IN      A

;; ANSWER SECTION:
hello-world.            30      IN      A       10.99.185.150

;; Query time: 9 msec
;; SERVER: 192.168.0.1#53(192.168.0.1)
;; WHEN: Tue Jan 05 19:57:27 CST 2021
;; MSG SIZE  rcvd: 45

# 3. 在本地直接运行 curl 能够得到响应
➜ curl hello-world:8000
Hello, world!

# 4. 退出当前环境
~/workspace via 🅒 base at ☸️  kind-kind (telepresence)
➜ exit
T: Your process has exited.
T: Exit cleanup in progress
T: Cleaning up Pod
(base)
~/workspace via 🅒 base at ☸️  kind-kind (telepresence) took 7m 56s
➜ curl hello-world:8000
curl: (6) Could not resolve host: hello-world
(base)
```