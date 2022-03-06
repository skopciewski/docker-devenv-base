TM := $(shell date +%Y%m%d)

build:
	docker build \
		-t skopciewski/devenv-base:latest \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from skopciewski/devenv-base:latest \
		.
.PHONY: build

push:
	docker push skopciewski/devenv-base:latest
	docker tag skopciewski/devenv-base:latest skopciewski/devenv-base:$(TM)
	docker push skopciewski/devenv-base:$(TM)
.PHONY: push

push_all:
	docker push skopciewski/devenv-base
.PHONY: push_all
