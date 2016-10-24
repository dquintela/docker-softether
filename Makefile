# This version-strategy uses git tags to set the version string
VERSION := $(shell git describe --tag --always --dirty)

# Which architecture to build - see $(ALL_ARCH) for options.
ALL_ARCH := i386 amd64
#ALL_ARCH := i386 amd64 armel rpi armhf

.PHONY: all-container all-push
.DEFAULT: all-container

all-container: $(addprefix container-, $(ALL_ARCH))

all-push: $(addprefix push-, $(ALL_ARCH))

BASEIMAGE_i386  := i386/ubuntu:16.04
BASEIMAGE_amd64 := ubuntu:16.04
BASEIMAGE_armel := armel/ubuntu:16.04
BASEIMAGE_rpi   := rpi/ubuntu:16.04
BASEIMAGE_armhf := armhf/ubuntu:16.04
CPU_BITS_i386   := 32bit
CPU_BITS_amd64  := 64bit
CPU_BITS_armel  := 32bit
CPU_BITS_rpi    := 32bit
CPU_BITS_armhf  := 32bit

IMAGE            = dquintela/softether-$(*)
CPU_BITS		 = $(CPU_BITS_$(*))
container-%: .Dockerfile-%
	sudo docker build \
		--build-arg SOFTETHER_CPU=$(CPU_BITS) \
		--build-arg BUILD_VERSION=$(VERSION) \
		-t $(IMAGE):latest \
		-t $(IMAGE):$(VERSION) \
		-f $< .
	sudo docker images -q $(IMAGE):$(VERSION) > $@

BASEIMAGE 		 = $(BASEIMAGE_$(*))
.Dockerfile-%: Dockerfile.in
	sed \
	    -e 's/ARG_BASEIMAGE/$(subst ',\',$(subst /,\/,$(subst &,\&,$(subst \,\\,$(BASEIMAGE)))))/g' \
	    Dockerfile.in > $@