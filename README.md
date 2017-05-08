# OpenRA Mod Template

This repository contains a bare development environment for creating a new mod/game on the [OpenRA](https://github.com/OpenRA/OpenRA) engine.

### Creating a new mod

The `example` mod included in this repository provides the bare minimum structure to launch to the in-game main menu for the sole purpose of demonstrating the environment.

It is not recommended or supported to use the `example` mod as the basis for a new OpenRA mod; you should instead adapt one of the official mods using the following procedure:
* Delete the `mods/example` directory.
* Choose one of the default OpenRA mods to use as a base for your mod.  In this example we will assume you are copying `cnc`.
* Choose a new internal name / id for you mod.  In this example we will assume you are using `mynewmod`.
* Copy `engine/mods/cnc` to `mods/mynewmod`.
* Open `mods/mynewmod/mod.yaml` and make the following changes:
   * In the `Metadata` section set your mod title and version.
   * In the `Packaging` section replace `$cnc: cnc` with `$mynewmod: mynewmod`.  This tells OpenRA that the explicit mount `mymod` should refer to the root of your mod package.
   * Change all lines that start with `cnc|` to `mynewmod|`.  This updates the explicit mount references to account for the change that you have just made above.
* Open `mod.config` and replace `MOD_ID="example"` near the top of the file with `MOD_ID="mynewmod"`.

You should now have a functioning stand-alone clone of the `cnc` mod that you can adapt / replace piece by piece with your own project.

If you don't plan on including any custom C# logic in your mod then you should delete `ExampleMod.sln` and the `OpenRA.Mods.Example` directory. If you do plan on including custom logic, then you will need to make some futher changes:
   * TODO: Explain updating the GUIDs, project name, and changing the build output to `mods/mynewmod/`

### Developing / running your in-development mod

Run the `launch-game.sh` (Linux/macOS) or `launch-game.cmd` (Windows) scripts to run your mod in development mode.
Before you run this for the first time you must fetch and compile the engine code by running the `TODO` (Linux/macOS) or `TODO` (Windows) script.

The first run scripts will automate the following:
   * `git submodule update --init`
   * `cd engine && make dependencies && make`

### Packaging your mod for distribution

When you are ready to share your mod with other players you have two options:
* Run the `TODO` (Linux/macOS) or `TODO` (Windows) scripts to generate a directory containing a self-contained version of your mod and the OpenRA engine that can be run by players on any operating system.
* Run the `TODO` script (Linux only) to generate OS-specific installers for players on Windows, macOS, and Debian-based Linux distributions.

### Updating your mod for new OpenRA engine or mod template versions.

It is no longer necessary to update your mod for every new OpenRA release, but if you want to take advantage of new engine features then the following outline explains how to update your mod:
* Make sure you have a backup of your mod directory.  The upgrade probably won't work the first time.  We *strongly* recommend that you use git to manage your mod development.
* Read the [changelog](https://github.com/OpenRA/OpenRA/wiki/Changelog) for the new release, paying close attention to any warnings or instructions in the "Engine / Modding" section.
* Check for new versions of this mod template, and copy any new or updated files into your mod.
* Update the `engine` submodule reference or directory to point at the new version of the OpenRA engine and run the `TODO` (Linux/macOS) or `TODO` (Windows) script to compile the new engine version.
* Use `OpenRA.Utility.exe`'s `--upgrade-mod` command to automatically update your mod rules for most of the changes in the new engine.  Pay close attention to any error messages, you may need to manually change some of your rules before or after the utility successfully completes.
* `OpenRA.Utility.exe` may make unwanted changes (e.g. changing formatting or discarding comments), so we recommend using a git client to preview the automated changes, and discard or manually fix any unwanted changes.