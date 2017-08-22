This repository contains a bare development environment for creating a new mod/game on the [OpenRA](https://github.com/OpenRA/OpenRA) engine.

These scripts and support files wrap and automatically manage a copy of the OpenRA game engine and common files, and provide entrypoints to run development versions of your project and to generate platform-specific installers for your players.

The key scripts in this SDK are:

| Windows               | Linux / macOS            | Purpose
| --------------------- | ------------------------ | ------------- |
| make.cmd              | Makefile                 | Compiles your project and fetches dependencies (including the OpenRA engine).
| launch-game.cmd       | launch-game.sh           | Launches your project from the SDK directory.
| launch-server.cmd     | launch-server.sh         | Launches a dedicated server for your project from the SDK directory.
| utility.cmd           | utility.sh         | Launches the OpenRA Utility for your project.
| &lt;not available&gt; | packaging/package-all.sh | Generates release installers for your project.

To launch your project from the development environment you must first compile the project by running `make.cmd` (Windows), or opening a terminal in the SDK directory and running `make` (Linux / macOS).  You can then run `launch-game.cmd` (Windows) or `launch-game.sh` (Linux / macOS) to run your game.

The `example` mod included in this repository provides the bare minimum structure to launch to the in-game main menu for the sole purpose of demonstrating the SDK.  See [Getting Started](https://github.com/OpenRA/OpenRAModTemplate/wiki/Getting-Started) on the Wiki for instructions on how to adapt this template for your own projects.  For common questions, please see the [FAQ](https://github.com/OpenRA/OpenRAModSDK/wiki/FAQ).
