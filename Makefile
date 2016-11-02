# This version-strategy uses git tags to set the version string
VERSION          := $(shell git describe --tag --always --dirty)
UPSTREAM_VERSION := $(shell git ls-remote -h https://github.com/SoftEtherVPN/SoftEtherVPN.git master | cut -f 1 | cut -c1-7)
BUILD            := build
ALL_ARCH         := amd64 i386 armel rpi armhf
BASE_IMAGE_FILES := $(shell find base-image -type f -not -name 'Dockerfile*')
BASE_IMAGE_DIRS  := $(shell find base-image -type d)
QEMU_STATIC      := /usr/bin/qemu-arm-static /usr/bin/qemu-x86_64-static
ALL_APPS         := vpnserver vpnbridge vpnclient

.PRECIOUS: $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image) \
		   $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image/Dockerfile) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/, $(BASE_IMAGE_FILES))) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/base-image/host-qemu, $(QEMU_STATIC))) \
		   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(BUILD)/$(arch)/app-image/$(app))) \
		   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(BUILD)/$(arch)/app-image/$(app)/Dockerfile))		   

.PHONY:    all all-context all-container all-push clean

all: all-container

all-context: $(addprefix context-, $(ALL_ARCH)) \
			 $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),context-$(arch)-$(app)))

all-container: all-context $(addprefix container-, $(ALL_ARCH)) \
			   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),container-$(arch)-$(app)))

all-push: all-container $(addprefix push-, $(ALL_ARCH)) \
		  $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),push-$(arch)-$(app)))

clean:
	rm -Rf $(BUILD)
	
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
	@echo "About to login on docker hub with user $(DOCKER_USERNAME)"
	@ $(DOCKER) login -u=$(DOCKER_USERNAME) -p=$(DOCKER_PASSWORD)

IMAGE              = dquintela/softether-$(*)
IMAGE_TEMPLATE     = dquintela/softether-$(1)
APP_IMAGE_TEMPLATE = dquintela/softether-$(2)-$(1)
CPU_BITS		   = $(CPU_BITS_$(*))
CPU_BITS_TEMPLATE  = $(CPU_BITS_$(1))
BASEIMAGE 		   = $(BASEIMAGE_$(*))
BASEIMAGE_TEMPLATE = $(BASEIMAGE_$(1))
DOCKER             = docker

# ==============================================================================
# This block should generate the requirements as was in proceding targets by weren't working [See issue #1]
define ARCH_TEMPLATE
push-$(1): IMAGE = $$(call IMAGE_TEMPLATE,$(1))
push-$(1): container-$(1) docker-login
	$$(DOCKER) push $$(IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)
	@echo "pushed: $$(IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)"
	$$(DOCKER) push $$(IMAGE):$$(VERSION)
	@echo "pushed: $$(IMAGE):$$(VERSION)"
	$$(DOCKER) push $$(IMAGE):latest
	@echo "pushed: $$(IMAGE):latest"

container-$(1): IMAGE = $$(call IMAGE_TEMPLATE,$(1))
container-$(1): CPU_BITS = $$(call CPU_BITS_TEMPLATE,$(1))
container-$(1): context-$(1)
	$$(DOCKER) build \
		--pull \
		--build-arg SOFTETHER_CPU=$$(CPU_BITS) \
		--build-arg SOFTETHER_IMAGE_VERSION=$$(VERSION) \
		--build-arg SOFTETHER_UPSTREAM_VERSION=$$(UPSTREAM_VERSION) \
		-t $$(IMAGE):latest \
		-t $$(IMAGE):$$(VERSION) \
		-t $$(IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION) \
		$$(BUILD)/$(1)/base-image
	$$(DOCKER) images -q $$(IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)

context-$(1): $$(BUILD)/$(1)/base-image/Dockerfile \
		   $$(addprefix $$(BUILD)/$(1)/, $$(BASE_IMAGE_FILES)) \
		   $$(addprefix $$(BUILD)/$(1)/base-image/host-qemu, $$(QEMU_STATIC))
	@echo "Image files aggregated at $$@"

$$(BUILD)/$(1)/base-image/host-qemu/usr/bin: ; mkdir -p $$@
$$(foreach dir,$$(BASE_IMAGE_DIRS),$$(BUILD)/$(1)/$$(dir)): ; mkdir -p $$@

$$(BUILD)/$(1)/base-image/Dockerfile: BASEIMAGE = $$(call BASEIMAGE_TEMPLATE,$(1))
$$(BUILD)/$(1)/base-image/Dockerfile: base-image/Dockerfile.in | $$(BUILD)/$(1)/base-image
	sed \
		-e 's/ARG_BASEIMAGE/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$$(BASEIMAGE)))))/g' \
		$$< > $$@

.SECONDEXPANSION:
$$(BUILD)/$(1)/base-image/%: base-image/% | $$$$(@D)
	cp $$< $$@

$$(BUILD)/$(1)/base-image/host-qemu/usr/bin/%: /usr/bin/% | $$$$(@D)
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

# Container that extends from main and for each APP generates a simple image that runs the right entrypoint
define CONTAINER_APP_TEMPLATE
push-$(1)-$(2): APP_IMAGE = $$(call APP_IMAGE_TEMPLATE,$(1),$(2))
push-$(1)-$(2): container-$(1)-$(2) docker-login
	$$(DOCKER) push $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)
	@echo "pushed: $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)"
	$$(DOCKER) push $$(APP_IMAGE):$$(VERSION)
	@echo "pushed: $$(APP_IMAGE):$$(VERSION)"
	$$(DOCKER) push $$(APP_IMAGE):latest
	@echo "pushed: $$(APP_IMAGE):latest"

container-$(1)-$(2): APP_IMAGE = $$(call APP_IMAGE_TEMPLATE,$(1),$(2))
container-$(1)-$(2): context-$(1)-$(2)
	$$(DOCKER) build \
		-t $$(APP_IMAGE):latest \
		-t $$(APP_IMAGE):$$(VERSION) \
		-t $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION) \
		$$(BUILD)/$(1)/app-image/$(2)
	$$(DOCKER) images -q $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)

context-$(1)-$(2): $$(BUILD)/$(1)/app-image/$(2)/Dockerfile
	@echo "Image files aggregated at $$@"

$$(BUILD)/$(1)/app-image/$(2): ; mkdir -p $$@

$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: IMAGE = $$(call IMAGE_TEMPLATE,$(1))
$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: APP_BASEIMAGE = $$(IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)
$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: app-image/Dockerfile.in | $$(BUILD)/$(1)/app-image/$(2)
	sed \
		-e 's/ARG_BASEIMAGE/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$$(APP_BASEIMAGE)))))/g' \
		-e 's/ARG_APP/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$(2)))))/g' \
		$$< > $$@

endef
# Generate targets from ARCH_TEMPLATE
$(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(eval $(call CONTAINER_APP_TEMPLATE,$(arch),$(app)))))
