GO_PROTOC_VERSION := 1.0.0

.PHONY: container
container:
	docker build --tag kawaguchisan/go-protoc:${GO_PROTOC_VERSION} .

.PHONY: registry
registry: container
	docker push kawaguchisan/go-protoc:${GO_PROTOC_VERSION}
