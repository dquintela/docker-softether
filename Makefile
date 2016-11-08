# # This version-strategy uses git tags to set the version string
# This approach doesn't work on travis git version
# GIT_URL          := $(shell git remote get-url origin)
GIT_URL          := $(shell git config --get remote.origin.url)
GIT_REVISION     := $(shell git rev-parse --short HEAD)
VERSION          := $(shell git describe --tag --always --dirty)
UPSTREAM_VERSION := $(shell git ls-remote -h https://github.com/SoftEtherVPN/SoftEtherVPN.git master | cut -f 1 | cut -c1-7)
FULL_VERSION     := $(VERSION)-upstream-$(UPSTREAM_VERSION)
BUILD            := build
ALL_ARCH         := amd64 i386 armel rpi armhf aarch64
BASE_IMAGE_FILES := $(shell find base-image -type f -not -name 'Dockerfile*')
BASE_IMAGE_DIRS  := $(shell find base-image -type d)
QEMU_STATIC      := /usr/bin/qemu-arm-static /usr/bin/qemu-aarch64-static  /usr/bin/qemu-x86_64-static
ALL_APPS         := vpnserver vpnbridge vpnclient
SCHEMA_USAGE     := https://github.com/dquintela/docker-softether/blob/$(GIT_REVISION)/README.md
SCHEMA_URL       := https://github.com/dquintela/docker-softether

.PRECIOUS: $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image) \
		   $(foreach arch,$(ALL_ARCH),$(BUILD)/$(arch)/base-image/Dockerfile) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/, $(BASE_IMAGE_FILES))) \
		   $(foreach arch,$(ALL_ARCH),$(addprefix $(BUILD)/$(arch)/base-image/host-qemu, $(QEMU_STATIC))) \
		   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(BUILD)/$(arch)/app-image/$(app))) \
		   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(BUILD)/$(arch)/app-image/$(app)/Dockerfile))		   

.PHONY:    all all-context all-container all-push clean $(BUILD)/markdown.md

all: all-container

all-context: $(addprefix context-, $(ALL_ARCH)) \
			 $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),context-$(arch)-$(app)))

all-container: all-context $(addprefix container-, $(ALL_ARCH)) \
			   $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),container-$(arch)-$(app)))

all-push: all-container $(addprefix push-, $(ALL_ARCH)) \
		  $(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),push-$(arch)-$(app)))

clean:
	rm -Rf $(BUILD)
	
BASEIMAGE_amd64   := debian:jessie
BASEIMAGE_i386    := i386/debian:jessie
BASEIMAGE_armel   := armel/debian:jessie
BASEIMAGE_rpi     := resin/rpi-raspbian:jessie
BASEIMAGE_armhf   := armhf/debian:jessie
BASEIMAGE_aarch64 := aarch64/debian:jessie
CPU_BITS_amd64    := 64bit
CPU_BITS_i386     := 32bit
CPU_BITS_armel    := 32bit
CPU_BITS_rpi      := 32bit
CPU_BITS_armhf    := 32bit
CPU_BITS_aarch64  := 32bit

docker-login:
	@echo "About to login on docker hub with user $(DOCKER_USERNAME)"
	@ $(DOCKER) login -u=$(DOCKER_USERNAME) -p=$(DOCKER_PASSWORD)

#IMAGE               = dquintela/softether-$(*)
S_IMAGE_TEMPLATE     = softether-$(1)
S_APP_IMAGE_TEMPLATE = softether-$(2)-$(1)
IMAGE_TEMPLATE       = dquintela/$(call S_IMAGE_TEMPLATE,$(1))
APP_IMAGE_TEMPLATE   = dquintela/$(call S_APP_IMAGE_TEMPLATE,$(1),$(2))
#CPU_BITS		     = $(CPU_BITS_$(*))
CPU_BITS_TEMPLATE    = $(CPU_BITS_$(1))
#BASEIMAGE 		     = $(BASEIMAGE_$(*))
BASEIMAGE_TEMPLATE   = $(BASEIMAGE_$(1))
DOCKER               = docker

markdown: $(BUILD)/markdown.md

$(BUILD)/markdown.md: S_IMAGE=$(call S_IMAGE_TEMPLATE,$$arch)
$(BUILD)/markdown.md: S_APP_IMAGE=$(call S_APP_IMAGE_TEMPLATE,$$arch,$$app)
$(BUILD)/markdown.md: IMAGE=$(call IMAGE_TEMPLATE,$$arch)
$(BUILD)/markdown.md: APP_IMAGE=$(call APP_IMAGE_TEMPLATE,$$arch,$$app)
$(BUILD)/markdown.md:
	@echo S_IMAGE='$(S_IMAGE)'
	@echo S_APP_IMAGE='$(S_APP_IMAGE)'
	@echo IMAGE='$(IMAGE)'
	@echo APP_IMAGE='$(APP_IMAGE)'
	
	@echo -n "" > $@
	
	@############################################
	@# FIRST TABLE
	@############################################
	@echo -n "| image \ arch |" >> $@
	@for arch in $(ALL_ARCH) ; do \
	  echo -n " $$arch |" >> $@ ; \
	done
	@echo "" >> $@
	
	@echo -n "|---:|" >> $@
	@for arch in $(ALL_ARCH) ; do \
	  echo -n ":---:|" >> $@ ; \
	done
	@echo "" >> $@
	
	@echo -n "| base-image |" >> $@
	@for arch in $(ALL_ARCH) ; do \
	  echo -n " $(S_IMAGE) |" >> $@ ; \
	done
	@echo "" >> $@
	
	@for app in $(ALL_APPS) ; do \
	  echo -n "| $$app |" >> $@ ; \
	  for arch in $(ALL_ARCH) ; do \
	    echo -n " $(S_APP_IMAGE) |"  >> $@ ; \
	  done ; \
	  echo ""  >> $@ ; \
	done

	@############################################
	@# SECOND TABLE
	@############################################
	@echo "" >> $@
	
	@echo "| Image | Image Size | Image Version | Docker Pulls |" >> $@
	@echo "|------:|:-----------:|:----------:|:-------------:|" >> $@
	@for arch in $(ALL_ARCH) ; do \
	  echo "| $(IMAGE) | [![Image Size](https://images.microbadger.com/badges/image/$(IMAGE).svg)](https://microbadger.com/images/$(IMAGE)) | [![Image Version](https://images.microbadger.com/badges/version/$(IMAGE).svg)](https://microbadger.com/images/$(IMAGE)) | [![Docker Pulls](https://img.shields.io/docker/pulls/$(IMAGE).svg)](https://hub.docker.com/r/$(IMAGE)) |"  >> $@ ; \
	  for app in $(ALL_APPS) ; do \
	    echo "| $(APP_IMAGE) | [![Image Size](https://images.microbadger.com/badges/image/$(APP_IMAGE).svg)](https://microbadger.com/images/$(APP_IMAGE)) | [![Image Version](https://images.microbadger.com/badges/version/$(APP_IMAGE).svg)](https://microbadger.com/images/$(APP_IMAGE)) | [![Docker Pulls](https://img.shields.io/docker/pulls/$(APP_IMAGE).svg)](https://hub.docker.com/r/$(APP_IMAGE)) |" >> $@ ; \
	  done ; \
	done
	
	@echo "Markdown helper file generated at $@"

# ==============================================================================
# This block should generate the requirements as was in proceding targets by weren't working [See issue #1]
define ARCH_TEMPLATE
push-$(1): IMAGE = $$(call IMAGE_TEMPLATE,$(1))
push-$(1): docker-login
	$$(DOCKER) push $$(IMAGE):latest
	@echo "pushed: $$(IMAGE):latest"
	$$(DOCKER) push $$(IMAGE):$$(FULL_VERSION)
	@echo "pushed: $$(IMAGE):$$(FULL_VERSION)"

pull-$(1): IMAGE = $$(call IMAGE_TEMPLATE,$(1))
pull-$(1):
	@echo "pulling: $$(IMAGE):latest"
	$$(DOCKER) pull $$(IMAGE):latest || true
	@echo "pulling: $$(IMAGE):$$(FULL_VERSION)"
	$$(DOCKER) pull $$(IMAGE):$$(FULL_VERSION) || true

container-$(1): IMAGE = $$(call IMAGE_TEMPLATE,$(1))
container-$(1): CPU_BITS = $$(call CPU_BITS_TEMPLATE,$(1))
container-$(1): context-$(1)
	$$(DOCKER) build \
		--pull \
		--build-arg VCS_URL=$$(GIT_URL) \
		--build-arg VCS_REF=$$(GIT_REVISION) \
		--build-arg IMAGE_VERSION=$$(FULL_VERSION) \
		--build-arg UPSTREAM_VERSION=$$(UPSTREAM_VERSION) \
		--build-arg SOFTETHER_CPU=$$(CPU_BITS) \
		--build-arg SCHEMA_USAGE=$$(SCHEMA_USAGE) \
		--build-arg SCHEMA_URL=$$(SCHEMA_URL) \
		-t $$(IMAGE):latest \
		-t $$(IMAGE):$$(FULL_VERSION) \
		$$(BUILD)/$(1)/base-image
	$$(DOCKER) images -q $$(IMAGE):$$(FULL_VERSION)

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
		-e 's/ARG_ARCH/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$(1)))))/g' \
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
push-$(1)-$(2): docker-login
	$$(DOCKER) push $$(APP_IMAGE):latest
	@echo "pushed: $$(APP_IMAGE):latest"
	$$(DOCKER) push $$(APP_IMAGE):$$(FULL_VERSION)
	@echo "pushed: $$(APP_IMAGE):$$(FULL_VERSION)"

pull-$(1)-$(2): APP_IMAGE = $$(call APP_IMAGE_TEMPLATE,$(1),$(2))
pull-$(1)-$(2):
	@echo "pulling: $$(APP_IMAGE):latest"
	$$(DOCKER) pull $$(APP_IMAGE):latest || true
	@echo "pulling: $$(APP_IMAGE):$$(FULL_VERSION)"
	$$(DOCKER) pull $$(APP_IMAGE):$$(FULL_VERSION) || true

container-$(1)-$(2): APP_IMAGE = $$(call APP_IMAGE_TEMPLATE,$(1),$(2))
container-$(1)-$(2): context-$(1)-$(2)
	$$(DOCKER) build \
		--build-arg VCS_URL=$$(GIT_URL) \
		--build-arg VCS_REF=$$(GIT_REVISION) \
		--build-arg IMAGE_VERSION=$$(FULL_VERSION) \
		--build-arg SCHEMA_USAGE=$$(SCHEMA_USAGE) \
		--build-arg SCHEMA_URL=$$(SCHEMA_URL) \
		-t $$(APP_IMAGE):latest \
		-t $$(APP_IMAGE):$$(FULL_VERSION) \
		$$(BUILD)/$(1)/app-image/$(2)
	$$(DOCKER) images -q $$(APP_IMAGE):$$(FULL_VERSION)

context-$(1)-$(2): $$(BUILD)/$(1)/app-image/$(2)/Dockerfile
	@echo "Image files aggregated at $$@"

$$(BUILD)/$(1)/app-image/$(2): ; mkdir -p $$@

$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: IMAGE = $$(call IMAGE_TEMPLATE,$(1))
$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: APP_BASEIMAGE = $$(IMAGE):$$(FULL_VERSION)
$$(BUILD)/$(1)/app-image/$(2)/Dockerfile: app-image/Dockerfile.in | $$(BUILD)/$(1)/app-image/$(2)
	sed \
		-e 's/ARG_BASEIMAGE/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$$(APP_BASEIMAGE)))))/g' \
		-e 's/ARG_ARCH/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$(1)))))/g' \
		-e 's/ARG_APP/$$(subst ',\',$$(subst /,\/,$$(subst &,\&,$$(subst \,\\,$(2)))))/g' \
		$$< > $$@

endef
# Generate targets from ARCH_TEMPLATE
$(foreach arch,$(ALL_ARCH),$(foreach app,$(ALL_APPS),$(eval $(call CONTAINER_APP_TEMPLATE,$(arch),$(app)))))
