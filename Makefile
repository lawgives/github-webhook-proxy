# Makefile for creating container file
# Override these with environmental variables
BRANCH?=master
VERSION?=`cat VERSION`

### Do not override below

user=legalio
app=github-webhook-proxy
branch=$(BRANCH)
version=$(VERSION)
bundle_cache_dir=.cache/bundle
#registry=docker.io
docker_deps_dir=${PWD}/_build/docker-deps
go_static_builder=docker run --rm -v $(docker_deps_dir):/go -e CGO_ENABLED=0 docker.io/hosh/golang-alpine:1.5.4
go_bin=$(go_static_builder) go

prod_build=_build/prod

all: docker-image

docker-image: $(docker_deps_dir)/bin/dinit
	echo "Building release: ${VERSION}"
	# docker build --tag=$(user)/$(app):$(version) .

rel: compile
	MIX_ENV=prod mix release

compile: $(prod_build)

$(prod_build): deps
	MIX_ENV=prod mix compile

deps:
	mix deps.get

push:
	docker push $(user)/$(app):$(version)

push-latest:
	docker push $(user)/$(app):latest

push-all: push push-latest

$(docker_deps_dir):
	mkdir -p  $(docker_deps_dir)

$(docker_deps_dir)/bin/dinit: $(docker_deps_dir)
	#$(go_bin) get build -a -tags netgo -installsuffix netgo
	$(go_bin) get -v -a -tags netgo -installsuffix netgo github.com/miekg/dinit

clean: clean-rel

clean-all: clean-rel clean-deps clean-docker-deps

clean-rel:
	rm -fr $(prod_build)
	rm -fr rel

clean-docker-deps:
	rm -fr $(docker_deps_dir)

clean-deps:
	rm -fr deps

.PHONY: all docker-image rel compile push push-latest push-all clean clean-all clean-rel clean-deps
