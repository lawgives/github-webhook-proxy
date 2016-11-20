# Makefile for creating container file
# Override these with environmental variables
BRANCH?=master
VERSION?=`cat VERSION`

### Do not override below

user=legalio
app=github-webhook-proxy
branch=$(BRANCH)
version=$(VERSION)
#registry=docker.io

# Try to build with the user creating this
make_uid=`id -u`
make_gid=`id -g`
cache_dir=${PWD}/_build/.cache
mix_dir=$(cache_dir)/mix
hex_dir=$(cache_dir)/hex
# rebar3 requires a cache directory with correct permissions: https://github.com/erlang/rebar3/issues/1253#issuecomment-232232078
rebar3_dir=$(cache_dir)/rebar3

docker_deps_dir=${PWD}/_build/docker-deps
go_static_builder=docker run --rm -v $(docker_deps_dir):/go -e CGO_ENABLED=0 docker.io/hosh/golang-alpine:1.5.4
go_bin=$(go_static_builder) go

elixir_image=docker.io/legalio/alpine-elixir:1.3.4
rel_builder=docker run --rm -ti \
        --user $(make_uid):$(make_gid) \
	-v ${PWD}:/build \
	-v $(hex_dir):/home/app/.hex \
	-v $(mix_dir):/home/app/.mix \
	-v $(rebar3_dir):/home/app/.cache/rebar3 \
	-w /build \
	-e MIX_ENV=prod \
	$(elixir_image)

prod_build=_build/prod

all: docker-image

docker-image: $(docker_deps_dir)/bin/dinit
	echo "Building release: ${VERSION}"
	# docker build --tag=$(user)/$(app):$(version) .

rel: compile
	$(rel_builder) mix release

compile: $(prod_build)

$(prod_build): $(mix_dir) deps
	$(rel_builder) mix compile

deps: $(mix_dir)
	$(rel_builder) mix deps.get

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

$(mix_dir): $(hex_dir) $(rebar3_dir) $(cache_dir)
	mkdir -p $(mix_dir)
	$(rel_builder) mix local.hex --force
	$(rel_builder) mix local.rebar --force

$(hex_dir): $(cache_dir)
	mkdir -p $(hex_dir)

$(rebar3_dir): $(cache_dir)
	mkdir -p $(rebar3_dir)

$(cache_dir):
	mkdir -p $(cache_dir)

clean: clean-rel

clean-all: clean-rel clean-deps clean-cache clean-docker-deps

clean-rel: clean-deps clean-cache
	rm -fr $(prod_build)
	rm -fr rel

clean-dist: clean-rel clean-cache

clean-docker-deps:
	rm -fr $(docker_deps_dir)

clean-deps:
	rm -fr deps

clean-cache:
	rm -fr $(cache_dir)

.PHONY: all docker-image rel compile push push-latest push-all clean clean-all clean-rel clean-deps clean-cache
