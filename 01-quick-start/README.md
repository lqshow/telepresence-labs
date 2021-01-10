## Installing Telepresence(macOS)

```bash
# required by sshfs to mount the pod's filesystem
brew install --cask osxfuse

# installing telepresence
brew install datawire/blackbird/telepresence
```


## Quick example

telepresence 默认会使用当前的 kubectl 的 current context 来进行请求。

1. 在 Kubernetes 集群运行一个 hello-world 服务
	```bash
	kubectl run hello-world \
		--image=datawire/hello-world \
		--port=8000 \
		--expose
	```
2. 在本地启动 Telepresence，等待在 Kubernetes 集群中启动 network proxy pod  
	```bash
	# 启动一个指定部署名称的 Pod
	telepresence --new-deployment telepresence-lin --run-shell
	
	# 如果没有指定部署选项，将使用默认的、随机生成的名称
	telepresence --run-shell
	
	# 如果需要以 deployment 方式启动，需要设置环境变量 TELEPRESENCE_USE_DEPLOYMENT 为 true
	env TELEPRESENCE_USE_DEPLOYMENT=1 telepresence --new-deployment telepresence-lin --run-shell
	```
3. 启动后，可以直接连接 hello-world 服务
	```bash
	curl http://hello-world:8000/
	Hello, world!
	```
	**output**
	```bash
	➜ telepresence --new-deployment telepresence-lin --run-shell
	T: Using a Pod instead of a Deployment for the Telepresence proxy. If you experience problems, please file an issue!
	T: Set the environment variable TELEPRESENCE_USE_DEPLOYMENT to any non-empty value to force the old behavior, e.g.,
	T:     env TELEPRESENCE_USE_DEPLOYMENT=1 telepresence --run curl hello

	T: Starting proxy with method 'vpn-tcp', which has the following limitations: All processes are affected, only one telepresence can run per machine, and you can't use other VPNs. You may need to add
	T: cloud hosts and headless services with --also-proxy. For a full list of method limitations see https://telepresence.io/reference/methods.html
	T: Volumes are rooted at $TELEPRESENCE_ROOT. See https://telepresence.io/howto/volumes.html for details.
	T: Starting network proxy to cluster using new Pod telepresence-lin

	T: No traffic is being forwarded from the remote Deployment to your local machine. You can use the --expose option to specify which ports you want to forward.

	T: Connected. Flushing DNS cache.
	T: Setup complete. Launching your command.
	@kind-kind|bash-3.2$ curl http://hello-world:8000/
	Hello, world!
	@kind-kind|bash-3.2$
	```
	
	**browser**
	
	再用浏览器访问该域名，仍然起作用，说明 telepresence 其实影响了整个机器环境。
	
	![image](https://user-images.githubusercontent.com/8086910/104115857-bf7b1080-534e-11eb-9ee1-0d8976ecc9c0.png)

	**notes**
	
	我们能够看到当前的 shell 命令行环境实际是一个 local shell，也就是说可以通过这个 shell 环境，能够连接到远端的 Kubernetes 集群
	```bash
	@kind-kind|bash-3.2$ pwd
	/Users/linqiong/workspace
	@kind-kind|bash-3.2$
	```
	
	**kubernetes cluster**
	
	同时我们能够看到 telepresence 在 kubernetes 集群中新建了一个 Pod(telepresence-lin)，以此作为代理，方便本地环境能够直接访问到集群中的其他服务
	```bash
	➜ kubectl get pod
	NAME                         READY   STATUS    RESTARTS   AGE
	hello-world-f759786b-gqbcv   1/1     Running   0          15h
	telepresence-lin             1/1     Running   0          15m
	```
	
	**mount the pod's filesystem**
	
	*在 telepresence 运行的 shell 中*, 我们能够看到 Telepresence 将远端的文件系统通过 sshfs 挂载到本地
	
	```bash
	@kind-kind|bash-3.2$ mount
	telepresence@127.0.0.1:/ on /private/tmp/tel-7dyzx2mw/fs (osxfuse, nodev, nosuid, synchronous, mounted by linqiong)
	```
	
	```bash
	@kind-kind|bash-3.2$ cd $TELEPRESENCE_ROOT/$TELEPRESENCE_MOUNTS
	@kind-kind|bash-3.2$ pwd
	/tmp/tel-7dyzx2mw/fs/var/run/secrets/kubernetes.io/serviceaccount
	@kind-kind|bash-3.2$ ls -lha
	total 56
	drwxrwxrwt  1 linqiong  staff   140B Jan  5 12:25 .
	drwxr-xr-x  1 linqiong  staff   4.0K Jan  5 12:25 ..
	drwxr-xr-x  1 linqiong  staff   100B Jan  5 12:25 ..2021_01_05_04_25_59.806039063
	lrwxrwxrwx  1 linqiong  staff    31B Jan  5 12:25 ..data -> ..2021_01_05_04_25_59.806039063
	lrwxrwxrwx  1 linqiong  staff    13B Jan  5 12:25 ca.crt -> ..data/ca.crt
	lrwxrwxrwx  1 linqiong  staff    16B Jan  5 12:25 namespace -> ..data/namespace
	lrwxrwxrwx  1 linqiong  staff    12B Jan  5 12:25 token -> ..data/token
	```
4. Telepresence 提供的环境变量

	```bash
	# 这些环境变量只有在当前 shell 环境存在，本地其他 shell 不可见
	@kind-kind|bash-3.2$ env |grep TELEPRESENCE
	TELEPRESENCE_NAMESERVER=8.8.8.8
	TELEPRESENCE_CONTAINER=telepresence
	TELEPRESENCE_POD=telepresence-lin
	TELEPRESENCE_ROOT=/tmp/tel-7dyzx2mw/fs
	TELEPRESENCE_MOUNTS=/var/run/secrets/kubernetes.io/serviceaccount
	```
5. 退出 local shell, 自动做清理工作
	- 删除 kubernetes 集群中的 telepresence-lin pod
	- 同时 unmount the pod's filesystem
	
	```bash
	@kind-kind|bash-3.2$ exit
	exit
	T: Your process exited with return code 6.
	T: Exit cleanup in progress
	T: Cleaning up Pod
	```