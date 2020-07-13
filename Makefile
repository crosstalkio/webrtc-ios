DEPOT_TOOLS := depot_tools
SRC := src
BUILD := build

MILESTONE := 83
BRANCH_HEAD := 4103

BINTRAY_USER ?=
BINTRAY_API_KEY ?=

all: depot_tools fetch sync patch framework

depot_tools:
ifeq (,$(wildcard $(DEPOT_TOOLS)))
	git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git $(DEPOT_TOOLS)
else
	cd $(DEPOT_TOOLS) && git checkout master && git pull
endif

fetch:
ifeq (,$(wildcard $(SRC)))
	PATH=$$PATH:$(realpath $(DEPOT_TOOLS)) fetch --nohooks webrtc_ios
endif
	cd $(SRC) && git fetch origin refs/branch-heads/$(BRANCH_HEAD) && git checkout branch-heads/$(BRANCH_HEAD)

sync:
	cd $(SRC) && PATH=$$PATH:$(realpath $(DEPOT_TOOLS)) gclient sync

patch: reset
	cd $(SRC) && git apply ../patches/*.patch

reset:
	cd $(SRC) && git reset --hard

framework:
	mkdir -p $(BUILD)
	cd $(SRC) && PATH=$$PATH:$(realpath $(DEPOT_TOOLS)) ./tools_webrtc/ios/build_ios_libs.sh \
		--output-dir=$(realpath .)/$(BUILD)

publish:
	rm -rf WebRTC.framework
	cp -r $(BUILD)/WebRTC.framework .
	$(eval tag := $(MILESTONE).$(shell cd $(SRC) && git rev-list --format=%B --max-count=1 HEAD | grep -oh $(BRANCH_HEAD)@{#.*} | sed 's/@{#/./g' | sed 's/}//g'))
	sed s/%%version%%/$(tag)/g CrossTalkWebRTC.podspec.in > CrossTalkWebRTC.podspec
	git commit  -a -m "published $(tag)"
	git push
	git tag $(tag)
	git push origin $(tag)

pod:
	pod lib lint
	pod trunk push CrossTalkWebRTC.podspec

.PHONY: all depot_tools fetch sync patch reset framework publish
