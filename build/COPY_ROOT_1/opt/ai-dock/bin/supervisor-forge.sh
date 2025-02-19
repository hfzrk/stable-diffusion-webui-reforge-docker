#!/bin/bash

trap cleanup EXIT

LISTEN_PORT=${FORGE_PORT_LOCAL:-17860}
METRICS_PORT=${FORGE_METRICS_PORT:-27860}
SERVICE_URL="${FORGE_URL:-}"
QUICKTUNNELS=true

function cleanup() {
    kill $(jobs -p) > /dev/null 2>&1
    rm /run/http_ports/$PROXY_PORT > /dev/null 2>&1
    if [[ -z "$VIRTUAL_ENV" ]]; then
        deactivate
    fi
}

function start() {
    source /opt/ai-dock/etc/environment.sh
    source /opt/ai-dock/bin/venv-set.sh serviceportal
    source /opt/ai-dock/bin/venv-set.sh reForge
    
    if [[ ! -v FORGE_PORT || -z $FORGE_PORT ]]; then
        FORGE_PORT=${FORGE_PORT_HOST:-7860}
    fi
    PROXY_PORT=$FORGE_PORT
    SERVICE_NAME="SD Web UI reForge"
    
    file_content="$(
      jq --null-input \
        --arg listen_port "${LISTEN_PORT}" \
        --arg metrics_port "${METRICS_PORT}" \
        --arg proxy_port "${PROXY_PORT}" \
        --arg proxy_secure "${PROXY_SECURE,,}" \
        --arg service_name "${SERVICE_NAME}" \
        --arg service_url "${SERVICE_URL}" \
        '$ARGS.named'
    )"
    
    printf "%s" "$file_content" > /run/http_ports/$PROXY_PORT
    
    printf "Starting $SERVICE_NAME...\n"
    
    PLATFORM_ARGS=
    if [[ $XPU_TARGET = "CPU" ]]; then
        PLATFORM_ARGS="--always-cpu --skip-torch-cuda-test --no-half"
    fi
    # No longer skipping prepare-environment
    BASE_ARGS=""
    
    # Delay launch until micromamba is ready
    if [[ -f /run/workspace_sync || -f /run/container_config ]]; then
        fuser -k -SIGTERM ${LISTEN_PORT}/tcp > /dev/null 2>&1 &
        wait -n
        "$SERVICEPORTAL_VENV_PYTHON" /opt/ai-dock/fastapi/logviewer/main.py \
            -p $LISTEN_PORT \
            -r 5 \
            -s "${SERVICE_NAME}" \
            -t "Preparing ${SERVICE_NAME}" &
        fastapi_pid=$!
        
        while [[ -f /run/workspace_sync || -f /run/container_config ]]; do
            sleep 1
        done
        
        kill $fastapi_pid
        wait $fastapi_pid 2>/dev/null
    fi
    
    fuser -k -SIGKILL ${LISTEN_PORT}/tcp > /dev/null 2>&1 &
    wait -n
    
    ARGS_COMBINED="${PLATFORM_ARGS} ${BASE_ARGS} $(cat /etc/forge_args.conf)"
    printf "Starting %s...\n" "${SERVICE_NAME}"

    cd /opt/stable-diffusion-webui-reForge
    source "$REFORGE_VENV/bin/activate"  # changed from $FORGE_VENV
    LD_PRELOAD=libtcmalloc.so python launch.py \
        ${ARGS_COMBINED} --port ${LISTEN_PORT}
}

start 2>&1