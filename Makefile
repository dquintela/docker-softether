# This version-strategy uses git tags to set the version string
VERSION := $(shell git describe --tag --always --dirty)

# Which architecture to build - see $(ALL_ARCH) for options.
ALL_ARCH := i386 amd64
#ALL_ARCH := i386 amd64 armel rpi armhf

.PHONY: default all-container all-push docker-login clean clean-container
all: container-armel

clean: clean-container clean-assets

all-container: $(addprefix .Dockerfile-, $(ALL_ARCH)) $(addprefix container-, $(ALL_ARCH))

all-push: all-container $(addprefix push-, $(ALL_ARCH))

clean-container: 
	rm -f $(addprefix container-, $(ALL_ARCH)) $(addprefix .Dockerfile-, $(ALL_ARCH))
	
clean-assets:
	rm -Rf assets/usr/bin
	
BASEIMAGE_i386  := i386/ubuntu:16.04
BASEIMAGE_amd64 := ubuntu:16.04
BASEIMAGE_armel := armel/debian:jessie
BASEIMAGE_rpi   := rpi/ubuntu:16.04
BASEIMAGE_armhf := armhf/ubuntu:16.04
CPU_BITS_i386   := 32bit
CPU_BITS_amd64  := 64bit
CPU_BITS_armel  := 32bit
CPU_BITS_rpi    := 32bit
CPU_BITS_armhf  := 32bit

docker-login:
	@docker login -u=$(DOCKER_USERNAME) -p=$(DOCKER_PASSWORD)

IMAGE            = dquintela/softether-$(*)
CPU_BITS		 = $(CPU_BITS_$(*))
BASEIMAGE 		 = $(BASEIMAGE_$(*))

push-%: container-% docker-login
	docker push $(IMAGE):$(VERSION)
	echo "pushed: $(IMAGE):$(VERSION)"
	docker push $(IMAGE):latest
	echo "pushed: $(IMAGE):latest"

container-%: .Dockerfile-% assets $(wildcard scripts/*)
	docker build \
		--build-arg SOFTETHER_CPU=$(CPU_BITS) \
		--build-arg SOFTETHER_IMAGE_VERSION=$(VERSION) \
		-t $(IMAGE):latest \
		-t $(IMAGE):$(VERSION) \
		-f $< .
	docker images -q $(IMAGE):$(VERSION) > $@

.Dockerfile-%: Dockerfile.in
	sed -e 's/ARG_BASEIMAGE/$(subst ',\',$(subst /,\/,$(subst &,\&,$(subst \,\\,$(BASEIMAGE)))))/g' Dockerfile.in > $@

assets: assets/usr/bin/qemu-arm-static assets/usr/bin/qemu-x86_64-static
#assets: $(patsubst %,assets%,$(wildcard /usr/bin/qemu-*-static))
		
assets/usr/bin:
	mkdir -p $@
	
assets/usr/bin/qemu-%-static: /usr/bin/qemu-%-static assets/usr/bin 
	cp $< $@