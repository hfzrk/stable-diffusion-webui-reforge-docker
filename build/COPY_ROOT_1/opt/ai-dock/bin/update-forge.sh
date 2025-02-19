#!/bin/bash
umask 002

source /opt/ai-dock/bin/venv-set.sh reForge

if [[ -n "${FORGE_REF}" ]]; then
    ref="${FORGE_REF}"
else
    # The latest tagged release
    ref="$(curl -s https://api.github.com/repos/Panchovix/stable-diffusion-webui-reForge/branches | \
            jq -r '.[3].name')"
fi

# -r argument has priority
while getopts r: flag
do
    case "${flag}" in
        r) ref="$OPTARG";;
    esac
done

[[ -n $ref ]] || { echo "Failed to get update target"; exit 1; }

printf "Updating WebUI reForge (${ref})...\n"

cd /opt/stable-diffusion-webui-reForge
git fetch --tags
git checkout ${ref}
git pull

"$REFORGE_VENV_PIP" install --no-cache-dir -r requirements.txt
