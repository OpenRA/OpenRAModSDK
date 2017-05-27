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

.PHONY: utility fetch-engine build build-engine clean clean-engine version check-scripts check test
.DEFAULT_GOAL := build

VERSION = $(shell git name-rev --name-only --tags --no-undefined HEAD 2>/dev/null || echo git-`git rev-parse --short HEAD`)
MOD_ID = $(shell awk -F= '/MOD_ID/ { print $$2 }' mod.config)
INCLUDE_DEFAULT_MODS = $(shell awk -F= '/INCLUDE_DEFAULT_MODS/ { print $$2 }' mod.config)

MOD_SEARCH_PATHS = "$(shell python -c "import os; print(os.path.realpath('.'))")/mods"
ifeq ("$(INCLUDE_DEFAULT_MODS)","True")
	MOD_SEARCH_PATHS = "$(MOD_SEARCH_PATHS),./mods"
endif

MANIFEST_PATH = "mods/$(MOD_ID)/mod.yaml"

HAS_MSBUILD = $(shell command -v msbuild 2> /dev/null)
HAS_LUAC = $(shell command -v luac 2> /dev/null)
LUA_FILES = $(shell find mods/*/maps/* -iname '*.lua')

utility:
	@test -f engine/OpenRA.Utility.exe || (printf "OpenRA.Utility.exe not found! Build the engine first.\n"; exit 1)

fetch-engine:
	@test -f engine/OpenRA.sln || git submodule update --init

build: build-engine
ifeq ("$(HAS_MSBUILD)","")
	@xbuild /nologo /verbosity:quiet /p:TreatWarningsAsErrors=true
else
	@msbuild /t:Rebuild /nr:false
endif
	@printf "The mod logic has been built.\n"

build-engine: fetch-engine
	@cd engine && make
	@printf "The engine has been built.\n"

clean: clean-engine
ifeq ("$(HAS_MSBUILD)","")
	@xbuild /nologo /verbosity:quiet /p:TreatWarningsAsErrors=true /t:Clean
else
	@msbuild /t:Clean /nr:false
endif
	@printf "The mod logic been cleaned.\n"

clean-engine:
	@cd engine && make clean
	@printf "The engine directory has been cleaned.\n"

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
	@echo
	@echo "Checking for explicit interface violations..."
	@MOD_SEARCH_PATHS="${MOD_SEARCH_PATHS}" mono --debug engine/OpenRA.Utility.exe $(MOD_ID) --check-explicit-interfaces
	@echo
	@echo "Checking for code style violations in OpenRA.Mods.$(MOD_ID)..."
	@MOD_SEARCH_PATHS="${MOD_SEARCH_PATHS}" mono --debug engine/OpenRA.Utility.exe $(MOD_ID) --check-code-style OpenRA.Mods.$(MOD_ID)

test: utility
	@echo
	@echo "Testing $(MOD_ID) mod MiniYAML..."
	@MOD_SEARCH_PATHS="${MOD_SEARCH_PATHS}" mono --debug engine/OpenRA.Utility.exe $(MOD_ID) --check-yaml