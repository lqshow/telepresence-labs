
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

如果你期望开发环境与上生产的运行时环境完全相同，使用 Docker 模式调试项目时，需要使用用与生产环境的 Dockefile 来构建的镜像。 

```bash
telepresence --method container \
	--docker-run \
	--rm \
	-it \
	-v $(pwd):/workspace \
	lqshow/busybox-curl:1.28 /bin/sh
```