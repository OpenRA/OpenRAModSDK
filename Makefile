############################# INSTRUCTIONS #############################
#
# to compile, run:
#   make
#
# to remove the files created by compiling, run:
#   make clean
#
# to set the mods version, run:
#   make version [VERSION="custom-version"]
#
# to check lua scripts for syntax errors, run:
#   make check-scripts
#
# to check the official mods for erroneous yaml files, run:
#   make test
#
# to check the official mod dlls for StyleCop violations, run:
#   make check
#

.PHONY: utility build clean engine version check-scripts check test
.DEFAULT_GOAL := build

VERSION = $(shell git name-rev --name-only --tags --no-undefined HEAD 2>/dev/null || echo git-`git rev-parse --short HEAD`)
MOD_ID = $(shell awk -F= '/MOD_ID/ { print $$2 }' mod.config)
ENGINE_DIRECTORY = $(shell awk -F= '/ENGINE_DIRECTORY/ { print $$2 }' mod.config)
AUTOMATIC_ENGINE_MANAGEMENT = $(shell awk -F= '/AUTOMATIC_ENGINE_MANAGEMENT/ { print $$2 }' mod.config)

INCLUDE_DEFAULT_MODS = $(shell awk -F= '/INCLUDE_DEFAULT_MODS/ { print $$2 }' mod.config)

MOD_SEARCH_PATHS = "$(shell python -c "import os; print(os.path.realpath('.'))")/mods"
ifeq ($(INCLUDE_DEFAULT_MODS),"True")
	MOD_SEARCH_PATHS := "$(MOD_SEARCH_PATHS),./mods"
endif

MANIFEST_PATH = "mods/$(MOD_ID)/mod.yaml"

HAS_MSBUILD = $(shell command -v msbuild 2> /dev/null)
HAS_LUAC = $(shell command -v luac 2> /dev/null)
LUA_FILES = $(shell find mods/*/maps/* -iname '*.lua')

engine:
	@./fetch-engine.sh || (printf "Unable to continue without engine files\n"; exit 1)
	@cd $(ENGINE_DIRECTORY) && make core

utility: engine
	@test -f "$(ENGINE_DIRECTORY)/OpenRA.Utility.exe" || (printf "OpenRA.Utility.exe not found!\n"; exit 1)

build: engine
ifeq ("$(HAS_MSBUILD)","")
	@xbuild /nologo /verbosity:quiet /p:TreatWarningsAsErrors=true
else
	@msbuild /t:Rebuild /nr:false
endif
	@printf "The mod logic has been built.\n"

clean: engine
ifeq ("$(HAS_MSBUILD)","")
	@xbuild /nologo /verbosity:quiet /p:TreatWarningsAsErrors=true /t:Clean
else
	@msbuild /t:Clean /nr:false
endif
	@printf "The mod logic has been cleaned.\n"
	@cd $(ENGINE_DIRECTORY) && make clean
	@printf "The engine has been cleaned.\n"

version:
	@awk '{sub("Version:.*$$","Version: $(VERSION)"); print $0}' $(MANIFEST_PATH) > $(MANIFEST_PATH).tmp && \
	awk '{sub("/[^/]*: User$$", "/$(VERSION): User"); print $0}' $(MANIFEST_PATH).tmp > $(MANIFEST_PATH) && \
	rm $(MANIFEST_PATH).tmp
	@printf "Version changed to $(VERSION).\n"

check-scripts:
ifeq ("$(HAS_LUAC)","")
	@printf "'luac' not found.\n" && exit 1
endif
	@echo
	@echo "Checking for Lua syntax errors..."
ifneq ("$(LUA_FILES)","")
	@luac -p $(LUA_FILES)
endif

check: utility
	@echo "Checking for explicit interface violations..."
	@MOD_SEARCH_PATHS="$(MOD_SEARCH_PATHS)" mono --debug "$(ENGINE_DIRECTORY)/OpenRA.Utility.exe" $(MOD_ID) --check-explicit-interfaces
	@echo "Checking for code style violations in OpenRA.Mods.$(MOD_ID)..."
	@MOD_SEARCH_PATHS="$(MOD_SEARCH_PATHS)" mono --debug "$(ENGINE_DIRECTORY)/OpenRA.Utility.exe" $(MOD_ID) --check-code-style OpenRA.Mods.$(MOD_ID)

test: utility
	@echo "Testing $(MOD_ID) mod MiniYAML..."
	@MOD_SEARCH_PATHS="$(MOD_SEARCH_PATHS)" mono --debug "$(ENGINE_DIRECTORY)/OpenRA.Utility.exe" $(MOD_ID) --check-yaml