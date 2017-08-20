#!/bin/sh
# Helper script used to check and update engine dependencies
# This should not be called manually

command -v git >/dev/null 2>&1 || command -v curl >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires git or curl."; exit 1; }
command -v python >/dev/null 2>&1 || { echo >&2 "The OpenRA mod template requires python."; exit 1; }

TEMPLATE_LAUNCHER=$(python -c "import os; print(os.path.realpath('$0'))")
TEMPLATE_ROOT=$(dirname "${TEMPLATE_LAUNCHER}")

# shellcheck source=mod.config
. "${TEMPLATE_ROOT}/mod.config"

CURRENT_ENGINE_VERSION=$(cat "${ENGINE_DIRECTORY}/VERSION" 2> /dev/null)

if [ -f "${ENGINE_DIRECTORY}/VERSION" ] && [ "${CURRENT_ENGINE_VERSION}" = "${ENGINE_VERSION}" ]; then
	exit 0
fi

if [ "${AUTOMATIC_ENGINE_MANAGEMENT}" = "True" ]; then
	echo "OpenRA engine version ${ENGINE_VERSION} is required."

	if command -v git >/dev/null 2>&1; then
		if [ ! -d "${ENGINE_DIRECTORY}/.git" ]; then
			rm -rf "${ENGINE_DIRECTORY}"
			git clone "${AUTOMATIC_ENGINE_SOURCE_GIT}" "${ENGINE_DIRECTORY}"
		fi

		git --git-dir="${ENGINE_DIRECTORY}/.git" --work-tree="${ENGINE_DIRECTORY}" fetch --all
		git --git-dir="${ENGINE_DIRECTORY}/.git" --work-tree="${ENGINE_DIRECTORY}" checkout "${ENGINE_VERSION}"
	else
		if [ -d "${ENGINE_DIRECTORY}" ]; then
			if [ "${CURRENT_ENGINE_VERSION}" != "" ]; then
				echo "Deleting engine version ${CURRENT_ENGINE_VERSION}."
			else
				echo "Deleting existing engine (unknown version)."
			fi

			rm -rf "${ENGINE_DIRECTORY}"
		fi

		echo "Downloading engine..."
		curl -s -L -o "${AUTOMATIC_ENGINE_TEMP_ARCHIVE_NAME}" -O "${AUTOMATIC_ENGINE_SOURCE}" || exit 3

		# Github zipballs package code with a top level directory named based on the refspec
		# Extract to a temporary directory and then move the subdir to our target location
		REFNAME=$(unzip -qql "${AUTOMATIC_ENGINE_TEMP_ARCHIVE_NAME}" | head -n1 | tr -s ' ' | cut -d' ' -f5-)

		rm -rf "${AUTOMATIC_ENGINE_EXTRACT_DIRECTORY}"
		mkdir "${AUTOMATIC_ENGINE_EXTRACT_DIRECTORY}"
		unzip -qq -d "${AUTOMATIC_ENGINE_EXTRACT_DIRECTORY}" "${AUTOMATIC_ENGINE_TEMP_ARCHIVE_NAME}"
		mv "${AUTOMATIC_ENGINE_EXTRACT_DIRECTORY}/${REFNAME}" "${ENGINE_DIRECTORY}"
		rmdir "${AUTOMATIC_ENGINE_EXTRACT_DIRECTORY}"
		rm "${AUTOMATIC_ENGINE_TEMP_ARCHIVE_NAME}"
	fi

	echo "Compiling engine..."
	cd "${ENGINE_DIRECTORY}" || exit 1
	make version VERSION="${ENGINE_VERSION}"
	exit 0
fi

echo "Automatic engine management is disabled."
echo "Please manually update the engine to version ${ENGINE_VERSION}."
exit 1

