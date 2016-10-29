# This version-strategy uses git tags to set the version string
VERSION          := $(shell git describe --tag --always --dirty)
UPSTREAM_VERSION := $(shell git ls-remote -h https://github.com/SoftEtherVPN/SoftEtherVPN.git master | cut -f 1 | cut -c1-7)
BUILD            := build
ALL_ARCH         := amd64 i386 armel rpi armhf
BASE_IMAGE_FILES := $(shell find base-image -type f -not -name 'Dockerfile*')
QEMU_STATIC      := /usr/bin/qemu-arm-static /usr/bin/qemu-x86_64-static
ALL_APPS         := vpnserver vpnbridge vpnclient

.PRECIOUS: $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image) \
		   $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image/Dockerfile) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/, $(BASE_IMAGE_FILES))) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/base-image/host-qemu, $(QEMU_STATIC))) \
		   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(BUILD)/$(arch)/app-image/$(app))) \
		   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(BUILD)/$(arch)/app-image/$(app)/Dockerfile))		   

.PHONY:    all all-container all-push clean clean-container

all: all-container

all-container: $(addprefix container-, $(ALL_ARCH)) \
			   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),container-$(arch)-$(app)))

all-push: all-container $(addprefix push-, $(ALL_ARCH)) \
		  $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),push-$(arch)-$(app)))

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
	@echo "About to login on docker hub with user $(DOCKER_USERNAME)"
	@docker login -u=$(DOCKER_USERNAME) -p=$(DOCKER_PASSWORD)

IMAGE              = dquintela/softether-$(*)
IMAGE_TEMPLATE     = dquintela/softether-$(1)
APP_IMAGE_TEMPLATE = dquintela/softether-$(2)-$(1)
CPU_BITS		   = $(CPU_BITS_$(*))
BASEIMAGE 		   = $(BASEIMAGE_$(*))

push-%: container-% docker-login
	docker push $(IMAGE):$(VERSION)-upstream-$(UPSTREAM_VERSION)
	@echo "pushed: $(IMAGE):$(VERSION)-upstream-$(UPSTREAM_VERSION)"
	docker push $(IMAGE):$(VERSION)
	@echo "pushed: $(IMAGE):$(VERSION)"
	docker push $(IMAGE):latest
	@echo "pushed: $(IMAGE):latest"

container-%: $(BUILD)/%/base-image
	docker build \
		--pull \
		--build-arg SOFTETHER_CPU=$(CPU_BITS) \
		--build-arg SOFTETHER_IMAGE_VERSION=$(VERSION) \
		--build-arg SOFTETHER_UPSTREAM_VERSION=$(UPSTREAM_VERSION) \
		-t $(IMAGE):latest \
		-t $(IMAGE):$(VERSION) \
		-t $(IMAGE):$(VERSION)-upstream-$(UPSTREAM_VERSION) \
		$<
	docker images -q $(IMAGE):$(VERSION)-upstream-$(UPSTREAM_VERSION)

$(BUILD)/%/base-image: $(BUILD)/%/base-image/Dockerfile \
					   $(addprefix $(BUILD)/%/, $(BASE_IMAGE_FILES)) \
				       $(addprefix $(BUILD)/%/base-image/host-qemu, $(QEMU_STATIC))
	@echo "Image files aggregated at $@"

$(BUILD)/%/base-image/Dockerfile: base-image/Dockerfile.in
	@mkdir -p $(@D)
	sed \
		-e 's/ARG_BASEIMAGE/$(subst ',\',$(subst /,\/,$(subst &,\&,$(subst \,\\,$(BASEIMAGE)))))/g' \
		$< > $@

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

# Container that extends from main and for each APP generates a simple image that runs the right entrypoint
define CONTAINER_APP_TEMPLATE =
push-$(1)-$(2): APP_IMAGE = $$(call APP_IMAGE_TEMPLATE,$(1),$(2))
push-$(1)-$(2): container-$(1)-$(2) docker-login
	docker push $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)
	@echo "pushed: $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)"
	docker push $$(APP_IMAGE):$$(VERSION)
	@echo "pushed: $$(APP_IMAGE):$$(VERSION)"
	docker push $$(APP_IMAGE):latest
	@echo "pushed: $$(APP_IMAGE):latest"

container-$(1)-$(2): APP_IMAGE = $$(call APP_IMAGE_TEMPLATE,$(1),$(2))
container-$(1)-$(2): $$(BUILD)/$(1)/app-image/$(2)
	docker build \
		-t $$(APP_IMAGE):latest \
		-t $$(APP_IMAGE):$$(VERSION) \
		-t $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION) \
		$$<
	docker images -q $$(APP_IMAGE):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)

$$(BUILD)/$(1)/app-image/$(2): $$(BUILD)/$(1)/app-image/$(2)/Dockerfile
	@echo "Image files aggregated at $$@"

$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: APP_BASEIMAGE = $$(call IMAGE_TEMPLATE,$(1)):$$(VERSION)-upstream-$$(UPSTREAM_VERSION)
$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: app-image/Dockerfile.in
	@mkdir -p $$(@D)
	sed \
		-e 's/ARG_BASEIMAGE/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$$(APP_BASEIMAGE)))))/g' \
		-e 's/ARG_APP/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$(2)))))/g' \
		$$< > $$@

endef
# Generate targets from ARCH_TEMPLATE
$(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(eval $(call CONTAINER_APP_TEMPLATE,$(arch),$(app)))))
