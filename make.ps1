####### The starting point for the script is the bottom #######

###############################################################
########################## FUNCTIONS ##########################
###############################################################
function All-Command 
{
	$msBuild = FindMSBuild
	$msBuildArguments = "/t:Rebuild /nr:false"
	if ($msBuild -eq $null)
	{
		echo "Unable to locate an appropriate version of MSBuild."
	}
	else
	{
		$proc = Start-Process $msBuild $msBuildArguments -NoNewWindow -PassThru -Wait
		if ($proc.ExitCode -ne 0)
		{
			echo "Build failed. If just the development tools failed to build, try installing Visual Studio. You may also still be able to run the game."
		}
		else
		{
			echo "Build succeeded."
		}
	}
}

function Clean-Command 
{
	$msBuild = FindMSBuild
	$msBuildArguments = "/t:Clean /nr:false"
	if ($msBuild -eq $null)
	{
		echo "Unable to locate an appropriate version of MSBuild."
	}
	else
	{
		$proc = Start-Process $msBuild $msBuildArguments -NoNewWindow -PassThru -Wait
		rm *.dll
		rm *.dll.config
		rm mods/*/*.dll
		rm *.pdb
		rm mods/*/*.pdb
		rm *.exe
		rm ./*/bin -r
		rm ./*/obj -r
		echo "Clean complete."
	}
}

function Version-Command 
{
	if ($command.Length -gt 1)
	{
		$version = $command[1]
	}
	elseif (Get-Command 'git' -ErrorAction SilentlyContinue)
	{
		$gitRepo = git rev-parse --is-inside-work-tree
		if ($gitRepo)
		{
			$version = git name-rev --name-only --tags --no-undefined HEAD 2>$null
			if ($version -eq $null)
			{
				$version = "git-" + (git rev-parse --short HEAD)
			}
		}
		else
		{
			echo "Not a git repository. The version will remain unchanged."
		}
	}
	else
	{
		echo "Unable to locate Git. The version will remain unchanged."
	}
	
	if ($version -ne $null)
	{
		$mod = "mods/" + $modID + "/mod.yaml"
		$replacement = (gc $mod) -Replace "Version:.*", ("Version: {0}" -f $version)
		sc $mod $replacement

		$prefix = $(gc $mod) | Where { $_.ToString().EndsWith(": User") }
		if ($prefix -and $prefix.LastIndexOf("/") -ne -1)
		{
			$prefix = $prefix.Substring(0, $prefix.LastIndexOf("/"))
		}
		$replacement = (gc $mod) -Replace ".*: User", ("{0}/{1}: User" -f $prefix, $version)
		sc $mod $replacement

		echo ("Version strings set to '{0}'." -f $version)
	}
}

function Test-Command
{
	if (Test-Path ./engine/OpenRA.Utility.exe)
	{
		$msg = "Testing " + $modID + " mod MiniYAML"
		echo $msg
		./engine/OpenRA.Utility.exe $modID --check-yaml
	}
	else
	{
		UtilityNotFound
	}
}

function Check-Command
{
	if (Test-Path ./engine/OpenRA.Utility.exe)
	{
		echo "Checking for explicit interface violations..."
		./engine/OpenRA.Utility.exe $modID --check-explicit-interfaces

		$msg = "Checking for code style violations in OpenRA.Mods." + $modID + "..."
		echo $msg
		./engine/OpenRA.Utility.exe $modID --check-code-style OpenRA.Mods.$modID
	}
	else
	{
		UtilityNotFound
	}
}

function Check-Scripts-Command
{
	if ((Get-Command "luac.exe" -ErrorAction SilentlyContinue) -ne $null)
	{
		echo "Testing Lua scripts..."
		foreach ($script in ls "mods/*/maps/*/*.lua")
		{
			luac -p $script
		}
		echo "Check completed!"
	}
	else
	{
		echo "luac.exe could not be found. Please install Lua."
	}
}

function Docs-Command
{
	if (Test-Path ./engine/OpenRA.Utility.exe)
	{
		./engine/OpenRA.Utility.exe $modID --docs | Out-File -Encoding "UTF8" DOCUMENTATION.md
		./engine/OpenRA.Utility.exe $modID --lua-docs | Out-File -Encoding "UTF8" Lua-API.md
		echo "Docs generated."
	}
	else
	{
		UtilityNotFound
	}
}

function FindMSBuild
{
	$key = "HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\4.0"
	$property = Get-ItemProperty $key -ErrorAction SilentlyContinue
	if ($property -eq $null -or $property.MSBuildToolsPath -eq $null)
	{
		return $null
	}

	$path = Join-Path $property.MSBuildToolsPath -ChildPath "MSBuild.exe"
	if (Test-Path $path)
	{
		return $path
	}

	return $null
}

function UtilityNotFound
{
	echo "OpenRA.Utility.exe could not be found. Build the project first using the `"all`" command."
}

function WaitForInput
{
	echo "Press enter to continue."
	while ($true)
	{
		if ([System.Console]::KeyAvailable)
		{
			exit
		}
		Start-Sleep -Milliseconds 50
	}
}

###############################################################
############################ Main #############################
###############################################################
if ($args.Length -eq 0)
{
	echo "Command list:"
	echo ""
	echo "  all             Builds the game, its development tools and the mod dlls."
	echo "  version         Sets the version strings for all mods to the latest"
	echo "                  version for the current Git branch."
	echo "  clean           Removes all built and copied files."
	echo "                  from the mods and the engine directories."
	echo "  test            Tests the mod's MiniYAML for errors."
	echo "  check           Checks .cs files for StyleCop violations."
	echo "  check-scripts   Checks .lua files for syntax errors."
	echo "  docs            Generates the trait and Lua API documentation."
	echo ""
	$command = (Read-Host "Enter command").Split(' ', 2)
}
else
{
	$command = $args
}

# Load the environment variables from the config file
# and get the mod ID from the local environment variable
$reader = [System.IO.File]::OpenText("mod.config")
while($null -ne ($line = $reader.ReadLine()))
{
	if ($line.StartsWith("MOD_ID"))
	{
		$env:MOD_ID = $line.Replace('MOD_ID=', '').Replace('"', '')
		$modID = $env:MOD_ID
	}

	if ($line.StartsWith("INCLUDE_DEFAULT_MODS"))
	{
		$env:INCLUDE_DEFAULT_MODS = $line.Replace('INCLUDE_DEFAULT_MODS=', '').Replace('"', '')
	}
}

$env:MOD_SEARCH_PATHS = (Get-Item -Path ".\" -Verbose).FullName + "\mods"
if ($env:INCLUDE_DEFAULT_MODS -eq "True")
{
	$env:MOD_SEARCH_PATHS = $env:MOD_SEARCH_PATHS + ",./mods"
}

# Run the same command on the engine's make file
if ($command -eq "all" -or $command -eq "clean")
{
	if (Test-Path ./engine/OpenRA.sln)
	{
		cd ".\engine\"
		$exp = ".\make.cmd " + $command
		Invoke-Expression $exp
		echo ""
		cd ..
	}
	else
	{
		if (Get-Command 'git' -ErrorAction SilentlyContinue)
		{
			$gitRepo = git rev-parse --is-inside-work-tree
			if ($gitRepo)
			{
				git submodule update --init

				if (Test-Path ./engine/OpenRA.sln)
				{
					cd ".\engine\"
					$exp = ".\make.cmd " + $command
					Invoke-Expression $exp
					echo ""
					cd ..
				}
				else
				{
					echo "Failed to initialize the submodule. You need to download the engine by hand."
					WaitForInput
				}
			}
			else
			{
				echo "Not a git repository. You need to download the engine by hand."
				WaitForInput
			}
		}
		else
		{
			echo "Unable to locate Git. You need to download the engine by hand."
			WaitForInput
		}
	}
}

$execute = $command
if ($command.Length -gt 1)
{
	$execute = $command[0]
}

switch ($execute)
{
	"all" { All-Command }
	"version" { Version-Command }
	"clean" { Clean-Command }
	"test" { Test-Command }
	"check" { Check-Command }
	"check-scripts" { Check-Scripts-Command }
	"docs" { Docs-Command }
	Default { echo ("Invalid command '{0}'" -f $command) }
}

# In case the script was called without any parameters we keep the window open
if ($args.Length -eq 0)
{
	WaitForInput
}
