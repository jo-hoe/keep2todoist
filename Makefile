include help.mk

# get root dir
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON_DIR := ${ROOT_DIR}.venv/Scripts/
IMAGE_NAME := "keep2todoist"
IMAGE_VERSION := 1.6.1

.DEFAULT_GOAL := start-docker

.PHONY: pull
pull:
	@git -C ${ROOT_DIR} pull


.PHONY: start-docker
start-docker:
	@docker run -v ./config.yaml:/app/config.yaml --restart always ghcr.io/flecmart/${IMAGE_NAME}:${IMAGE_VERSION}

.PHONY: generate-helm-docs
generate-helm-docs: ## re-generates helm docs using docker
	@docker run --rm --volume "$(ROOT_DIR)charts:/helm-docs" jnorwood/helm-docs:latest

.PHONY: start-cluster
start-cluster: # starts k3d cluster and registry
	@k3d cluster create --config ${ROOT_DIR}k3d/clusterconfig.yaml

.PHONY: start-k3d
start-k3d: start-cluster push-k3d ## run make `start-k3d api_key=<your_api_key>` start k3d cluster and deploy local code
	@helm install ${IMAGE_NAME} ${ROOT_DIR}charts/${IMAGE_NAME}  \
		--set image.repository=registry.localhost:5000/${IMAGE_NAME} --set image.tag=${IMAGE_VERSION} \
		-f ${ROOT_DIR}dev/config.yaml

.PHONY: stop-k3d
stop-k3d: ## stop K3d
	@k3d cluster delete --config ${ROOT_DIR}k3d/clusterconfig.yaml

.PHONY: restart-k3d
restart-k3d: stop-k3d start-k3d ## restarts K3d
	
.PHONY: push-k3d
push-k3d: # build and push docker image to local registry
	@docker build -f ${ROOT_DIR}Dockerfile . -t ${IMAGE_NAME}
	@docker tag ${IMAGE_NAME} localhost:5000/${IMAGE_NAME}:${IMAGE_VERSION}
	@docker push localhost:5000/${IMAGE_NAME}:${IMAGE_VERSION}