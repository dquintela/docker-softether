# This version-strategy uses git tags to set the version string
VERSION          := $(shell git describe --tag --always --dirty)
BUILD            := build
ALL_ARCH         := amd64 i386 armel rpi armhf
BASE_IMAGE_FILES := $(shell find base-image -type f -not -name 'Dockerfile*')
QEMU_STATIC      := /usr/bin/qemu-arm-static /usr/bin/qemu-x86_64-static

.PRECIOUS: $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image) \
		   $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image/Dockerfile) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/, $(BASE_IMAGE_FILES))) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/base-image/host-qemu, $(QEMU_STATIC))) 

.PHONY:    all all-container all-push clean clean-container

all: all-container

all-container: $(addprefix container-, $(ALL_ARCH))

all-push: all-container $(addprefix push-, $(ALL_ARCH))

clean: clean-container
	rmdir $(BUILD)

clean-container: 
	rm -Rf $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch))
	
BASEIMAGE_amd64 := debian:jessie
BASEIMAGE_i386  := i386/debian:jessie
BASEIMAGE_armel := armel/debian:jessie
BASEIMAGE_rpi   := resin/rpi-raspbian:jessie
BASEIMAGE_armhf := armhf/debian:jessie
CPU_BITS_amd64  := 64bit
CPU_BITS_i386   := 32bit
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
	@echo "pushed: $(IMAGE):$(VERSION)"
	docker push $(IMAGE):latest
	@echo "pushed: $(IMAGE):latest"

container-%: $(BUILD)/%/base-image
	docker build \
		--pull \
		--build-arg SOFTETHER_CPU=$(CPU_BITS) \
		--build-arg SOFTETHER_IMAGE_VERSION=$(VERSION) \
		-t $(IMAGE):latest \
		-t $(IMAGE):$(VERSION) \
		$<
	docker images -q $(IMAGE):$(VERSION)

$(BUILD)/%/base-image: $(BUILD)/%/base-image/Dockerfile \
					   $(addprefix $(BUILD)/%/, $(BASE_IMAGE_FILES)) \
				       $(addprefix $(BUILD)/%/base-image/host-qemu, $(QEMU_STATIC))
	@echo "Image files aggregated at $@"

$(BUILD)/%/base-image/Dockerfile: base-image/Dockerfile.in
	@mkdir -p $(@D)
	sed -e 's/ARG_BASEIMAGE/$(subst ',\',$(subst /,\/,$(subst &,\&,$(subst \,\\,$(BASEIMAGE)))))/g' $< > $@

# ==============================================================================
# This block should generate the requirements as was in proceding targets by weren't working [See issue #1]
define ARCH_TEMPLATE =
$$(BUILD)/$(1)/base-image/%: base-image/%
	@mkdir -p $$(@D)
	cp $$< $$@

$$(BUILD)/$(1)/base-image/host-qemu/usr/bin/%: /usr/bin/%
	@mkdir -p $$(@D)
	cp $$< $$@

endef
# Generate targets from ARCH_TEMPLATE
$(foreach arch,$(ALL_ARCH),$(eval $(call ARCH_TEMPLATE,$(arch))))
# ==============================================================================
# $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image/%): base-image/%
# 	@mkdir -p $(@D)
# 	cp $< $@
# 
# $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image/host-qemu/usr/bin/%): /usr/bin/%
# 	@mkdir -p $(@D)
# 	cp $< $@
# ==============================================================================
