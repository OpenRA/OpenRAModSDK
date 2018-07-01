This repository contains a bare development environment for creating a new mod/game on the [OpenRA](https://github.com/OpenRA/OpenRA) engine.

These scripts and support files wrap and automatically manage a copy of the OpenRA game engine and common files during development, and generates Windows installers, macOS .app bundles, and Linux [AppImages](https://appimage.org/) for distribution.

The key scripts in this SDK are:

| Windows               | Linux / macOS            | Purpose
| --------------------- | ------------------------ | ------------- |
| make.cmd              | Makefile                 | Compiles your project and fetches dependencies (including the OpenRA engine).
| launch-game.cmd       | launch-game.sh           | Launches your project from the SDK directory.
| launch-server.cmd     | launch-server.sh         | Launches a dedicated server for your project from the SDK directory.
| utility.cmd           | utility.sh         | Launches the OpenRA Utility for your project.
| &lt;not available&gt; | packaging/package-all.sh | Generates release installers for your project.

To launch your project from the development environment you must first compile the project by running `make.cmd` (Windows), or opening a terminal in the SDK directory and running `make` (Linux / macOS).  You can then run `launch-game.cmd` (Windows) or `launch-game.sh` (Linux / macOS) to run your game.

The `example` mod included in this repository provides the bare minimum structure to launch to the in-game main menu for the sole purpose of demonstrating the SDK.  See [Getting Started](https://github.com/OpenRA/OpenRAModTemplate/wiki/Getting-Started) on the Wiki for instructions on how to adapt this template for your own projects.  For common questions, please see the [FAQ](https://github.com/OpenRA/OpenRAModSDK/wiki/FAQ).  See [Updating to a new SDK or Engine version](https://github.com/OpenRA/OpenRAModSDK/wiki/Updating-to-a-new-SDK-or-Engine-version) for a guide on updating your mod a newer OpenRA release.

The OpenRA engine and SDK scripts are made available under the [GPLv3](https://github.com/OpenRA/OpenRA/blob/bleed/COPYING) license, and any executable code developed by a mod and loaded by the engine (i.e. custom mod DLLs, lua scripts) must be released under a compatible license.  Your mod data files (artwork, sound files, yaml, etc) are not part of your mod's source code, so your are free to distribute these assets under different terms (e.g. allowing redistribution in unmodified form, but not for use in other works).
