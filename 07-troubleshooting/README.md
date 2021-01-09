## 集群创建 proxy pod 过慢报错

集群资源问题，必须解决资源问题

```bash
➜ telepresence
T: Using a Pod instead of a Deployment for the Telepresence proxy. If you experience problems, please file an issue!
T: Set the environment variable TELEPRESENCE_USE_DEPLOYMENT to any non-empty value to force the old behavior, e.g.,
T:     env TELEPRESENCE_USE_DEPLOYMENT=1 telepresence --run curl hello

T: Starting proxy with method 'vpn-tcp', which has the following limitations: All processes are affected, only one telepresence can run per machine, and you can't use other VPNs. You may need to add cloud hosts and headless services with --also-
T: proxy. For a full list of method limitations see https://telepresence.io/reference/methods.html
T: Volumes are rooted at $TELEPRESENCE_ROOT. See https://telepresence.io/howto/volumes.html for details.
T: Starting network proxy to cluster using new Pod telepresence-1609744225-233484-67776

Looks like there's a bug in our code. Sorry about that!

Traceback (most recent call last):
  File "/usr/local/bin/telepresence/telepresence/cli.py", line 135, in crash_reporting
    yield
  File "/usr/local/bin/telepresence/telepresence/main.py", line 65, in main
    remote_info = start_proxy(runner)
  File "/usr/local/bin/telepresence/telepresence/proxy/operation.py", line 135, in act
    wait_for_pod(runner, self.remote_info)
  File "/usr/local/bin/telepresence/telepresence/proxy/remote.py", line 140, in wait_for_pod
    raise RuntimeError(
RuntimeError: Pod isn't starting or can't be found: {'conditions': [{'lastProbeTime': None, 'lastTransitionTime': '2021-01-04T07:10:33Z', 'status': 'True', 'type': 'Initialized'}, {'lastProbeTime': None, 'lastTransitionTime': '2021-01-04T07:10:33Z', 'message': 'containers with unready status: [telepresence]', 'reason': 'ContainersNotReady', 'status': 'False', 'type': 'Ready'}, {'lastProbeTime': None, 'lastTransitionTime': '2021-01-04T07:10:33Z', 'message': 'containers with unready status: [telepresence]', 'reason': 'ContainersNotReady', 'status': 'False', 'type': 'ContainersReady'}, {'lastProbeTime': None, 'lastTransitionTime': '2021-01-04T07:10:33Z', 'status': 'True', 'type': 'PodScheduled'}], 'containerStatuses': [{'image': 'datawire/telepresence-k8s:0.108', 'imageID': '', 'lastState': {}, 'name': 'telepresence', 'ready': False, 'restartCount': 0, 'started': False, 'state': {'waiting': {'reason': 'ContainerCreating'}}}], 'hostIP': '172.18.0.84', 'phase': 'Pending', 'qosClass': 'Burstable', 'startTime': '2021-01-04T07:10:33Z'}


Here are the last few lines of the logfile (see /Users/linqiong/telepresence.log for the complete logs):

 183.8 TEL | [99] captured in 0.97 secs.
 184.0 TEL | [100] Capturing: kubectl --context basebit-184-context@dev --namespace telepresence get pod telepresence-1609744225-233484-67776 -o json
 185.2 TEL | [100] captured in 1.18 secs.
 185.5 TEL | [101] Capturing: kubectl --context basebit-184-context@dev --namespace telepresence get pod telepresence-1609744225-233484-67776 -o json
 186.5 TEL | [101] captured in 0.96 secs.
 186.7 TEL | [102] Capturing: kubectl --context basebit-184-context@dev --namespace telepresence get pod telepresence-1609744225-233484-67776 -o json
 187.7 TEL | [102] captured in 0.98 secs.
 187.9 TEL | [103] Capturing: kubectl --context basebit-184-context@dev --namespace telepresence get pod telepresence-1609744225-233484-67776 -o json
 189.0 TEL | [103] captured in 1.05 secs.
 189.2 TEL | [104] Capturing: kubectl --context basebit-184-context@dev --namespace telepresence get pod telepresence-1609744225-233484-67776 -o json
 190.3 TEL | [104] captured in 1.10 secs.
 190.4 TEL | END SPAN remote.py:109(wait_for_pod)  182.5s
```


## 本地集群使用其他 VPN 报错

关闭机器的其他 VPN 服务，可正常使用。

但是如果你在家里，需要通过 VPN 连接公司内网环境的话，是不能断开的，可尝试修改 method 通过 docker 来启动。

```bash
# 通过 docker run 方式
telepresence --method container \
	--docker-run \
	-it \
	lqshow/busybox-curl:1.28 /bin/sh
```

```bash
➜ telepresence --run-shell
T: Using a Pod instead of a Deployment for the Telepresence proxy. If you experience problems, please file an issue!
T: Set the environment variable TELEPRESENCE_USE_DEPLOYMENT to any non-empty value to force the old behavior, e.g.,
T:     env TELEPRESENCE_USE_DEPLOYMENT=1 telepresence --run curl hello

T: How Telepresence uses sudo: https://www.telepresence.io/reference/install#dependencies
T: Invoking sudo. Please enter your sudo password.
Password:
T: Starting proxy with method 'vpn-tcp', which has the following limitations: All processes are affected, only one telepresence can run per machine, and you can't use other VPNs. You may need to add cloud hosts and headless services with --also-
T: proxy. For a full list of method limitations see https://telepresence.io/reference/methods.html
T: Volumes are rooted at $TELEPRESENCE_ROOT. See https://telepresence.io/howto/volumes.html for details.
T: Starting network proxy to cluster using new Pod telepresence-1609831615-006377-65710

T: No traffic is being forwarded from the remote Deployment to your local machine. You can use the --expose option to specify which ports you want to forward.


Looks like there's a bug in our code. Sorry about that!

Traceback (most recent call last):
  File "/usr/local/bin/telepresence/telepresence/cli.py", line 135, in crash_reporting
    yield
  File "/usr/local/bin/telepresence/telepresence/main.py", line 81, in main
    user_process = launch(
  File "/usr/local/bin/telepresence/telepresence/outbound/setup.py", line 111, in launch
    return launch_vpn(
  File "/usr/local/bin/telepresence/telepresence/outbound/local.py", line 126, in launch_vpn
    connect_sshuttle(runner, remote_info, also_proxy, ssh)
  File "/usr/local/bin/telepresence/telepresence/outbound/vpn.py", line 110, in connect_sshuttle
    raise RuntimeError("vpn-tcp tunnel did not connect")
RuntimeError: vpn-tcp tunnel did not connect


Here are the last few lines of the logfile (see /Users/linqiong/telepresence.log for the complete logs):

  52.5  12 | 2021-01-05T07:27:47+0000 [twisted.names.resolve.ResolverChain#debug] Query of unknown type 65 for b'p3.music.126.net.c.cdnhwc1.com'
  52.5  12 | 2021-01-05T07:27:47+0000 [stdout#info] 65 query: b'p3.music.126.net.c.cdnhwc1.com'
  52.5  12 | 2021-01-05T07:27:47+0000 [twisted.names.client.Resolver#debug] Query of unknown type 65 for b'p3.music.126.net.c.cdnhwc1.com'
  52.5  12 | 2021-01-05T07:27:47+0000 [DNSDatagramProtocol (UDP)] DNSDatagramProtocol starting on 25185
  52.5  12 | 2021-01-05T07:27:47+0000 [DNSDatagramProtocol (UDP)] Starting protocol <twisted.names.dns.DNSDatagramProtocol object at 0x7faf2093ea90>
  52.5  12 | 2021-01-05T07:27:47+0000 [stdout#info] A query: b'p3.music.126.net.c.cdnhwc1.com'
  52.5  12 | 2021-01-05T07:27:47+0000 [DNSDatagramProtocol (UDP)] DNSDatagramProtocol starting on 50124
  52.5  12 | 2021-01-05T07:27:47+0000 [DNSDatagramProtocol (UDP)] Starting protocol <twisted.names.dns.DNSDatagramProtocol object at 0x7faf2093ec88>
  52.6  12 | 2021-01-05T07:27:47+0000 [-] (UDP Port 25185 Closed)
  52.6  12 | 2021-01-05T07:27:47+0000 [-] Stopping protocol <twisted.names.dns.DNSDatagramProtocol object at 0x7faf2093ea90>
  52.6  12 | 2021-01-05T07:27:47+0000 [-] (UDP Port 50124 Closed)
  52.6  12 | 2021-01-05T07:27:47+0000 [-] Stopping protocol <twisted.names.dns.DNSDatagramProtocol object at 0x7faf2093ec88>

Would you like to file an issue in our issue tracker? You'll be able to review and edit before anything is posted to the public. We'd really appreciate the help improving our product. [Y/n]: n
T: Exit cleanup in progress
T: Cleaning up Pod
```