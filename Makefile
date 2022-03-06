TM := $(shell date +%Y%m%d)

build:
	docker build \
		-t skopciewski/devenv-base:latest \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from skopciewski/devenv-base:latest \
		.
.PHONY: build

push:
	docker push skopciewski/devenv-ruby:latest
	docker tag skopciewski/devenv-ruby:latest skopciewski/devenv-ruby:$(TM)
	docker push skopciewski/devenv-ruby:$(TM)
.PHONY: push

push_all:
	docker push skopciewski/devenv-base
.PHONY: push_all
