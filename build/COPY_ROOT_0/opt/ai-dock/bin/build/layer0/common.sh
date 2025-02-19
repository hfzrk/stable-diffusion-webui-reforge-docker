#!/bin/false

source /opt/ai-dock/etc/environment.sh

build_common_main() {
    build_common_create_venv
}

build_common_create_venv() {
    apt-get update
    $APT_INSTALL \
        "python${PYTHON_VERSION}" \
        "python${PYTHON_VERSION}-dev" \
        "python${PYTHON_VERSION}-venv"
    
    "python${PYTHON_VERSION}" -m venv "$REFORGE_VENV"  # changed from $FORGE_VENV
    "$REFORGE_VENV_PIP" install --no-cache-dir \   # changed from $FORGE_VENV_PIP
        ipykernel \
        ipywidgets
    "$REFORGE_VENV_PYTHON" -m ipykernel install \    # changed from $FORGE_VENV_PYTHON
        --name="forge" \
        --display-name="Python${PYTHON_VERSION} (webui)"
    # Add the default Jupyter kernel as an alias of webui
    "$REFORGE_VENV_PYTHON" -m ipykernel install \
        --name="python3" \
        --display-name="Python3 (ipykernel)"
}


build_common_run_tests() {
    installed_pytorch_version=$("$FORGE_VENV_PYTHON" -c "import torch; print(torch.__version__)")
    if [[ "$installed_pytorch_version" != "$PYTORCH_VERSION"* ]]; then
        echo "Expected PyTorch ${PYTORCH_VERSION} but found ${installed_pytorch_version}\n"
        exit 1
    fi
}

build_common_main "$@"