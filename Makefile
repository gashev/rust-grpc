.DEFAULT_GOAL := all

DOCKER_REGISTRY := docker-local:5000

create_docker_registry:
	docker run -d -p 5000:5000 --restart=always --name registry -v /mnt/registry:/var/lib/registry registry:2

stop_docker_registry:
	docker stop registry
	docker rm registry

destroy_docker_registry: stop_docker_registry
	rm -rf /mnt/registry

nginx_grpc_docker:
	docker build . -t ${DOCKER_REGISTRY}/nginx-grpc && docker push ${DOCKER_REGISTRY}/nginx-grpc

all:
	$(MAKE) -C rust-grpc-example
	$(MAKE) -C rust-grpc-hello-world
	$(MAKE) nginx_grpc_docker

deploy:
	kubectl create -f grpc.yaml