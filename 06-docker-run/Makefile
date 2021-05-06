SHELL := /bin/bash

ifeq ($(VERSION),)
VERSION := $(shell git describe --always --dirty)
endif

ARCH :=	amd64
IMAGE_REGISTRY ?= lqshow
IMAGE_NAME ?= docker-run-$(ARCH)

ifeq ($(IMAGE_REGISTRY),)
IMAGE := $(IMAGE_NAME)
else
IMAGE := $(IMAGE_REGISTRY)/$(IMAGE_NAME)
endif

CURRENT_DIR := $(shell pwd)

.PHONY: build-image
build-image:
	@docker build -t $(IMAGE):$(VERSION) --build-arg VERSION=$(VERSION) .

.PHONY: push-image
push-image:
	@docker push $(IMAGE):$(VERSION)

.PHONY: run-debug
run-debug: build-image
	@$(CURRENT_DIR)/.debug/debug.sh

.PHONY: build
build:
	@CGO_ENABLED=0 go build -a -installsuffix cgo -o server .