[![Docker Build](https://github.com/hfzrk/stable-diffusion-webui-reforge-docker/actions/workflows/docker-build.yml/badge.svg)](https://github.com/hfzrk/stable-diffusion-webui-reforge-docker/actions/workflows/docker-build.yml)

# Stable Diffusion WebUI reForge Docker Image

Run [Stable Diffusion WebUI reForge](https://github.com/Panchovix/stable-diffusion-webui-reForge) in a docker container locally or in the cloud.

>[!NOTE]  
>These images do not bundle models or third-party configurations. You should use a [provisioning script](https://github.com/ai-dock/base-image/wiki/4.0-Running-the-Image#provisioning-script) to automatically configure your container. You can find examples in `config/provisioning`.
---
>[!NOTE]
>This image (sha256:6fa370a6d89b3c911068ef6bd819c366c33f00c1902ecf63de50b6aa6cebea85) is tested working on Vast.ai

## Documentation

All AI-Dock containers share a common base which is designed to make running on cloud services such as [vast.ai](https://link.ai-dock.org/vast.ai) as straightforward and user friendly as possible.

Common features and options are documented in the [base wiki](https://github.com/ai-dock/base-image/wiki) but any additional features unique to this image will be detailed below.

#### Version Tags

Only use `latest`

Supported Python versions: `3.10`

Supported Platforms: This fork only supports CUDA you can fork it to build for ROCm and CPU

## Additional Environment Variables
| Variable                 | Description |
| ------------------------ | ----------- |
| `AUTO_UPDATE`            | Update Web UI reForge on startup (default `false`) |
| `CIVITAI_TOKEN`          | Authenticate download requests from Civitai - Required for gated models |
| `HF_TOKEN`               | Authenticate download requests from HuggingFace - Required for gated models (SD3, FLUX, etc.) |
| `REFORGE_ARGS`           | Startup arguments. eg. `--no-half --api` |
| `REFORGE_PORT_HOST`      | Web UI port (default `7860`) |
| `REFORGE_REF`            | Git reference for auto update. Accepts branch, tag or commit hash. Default: latest release |
| `REFORGE_URL`            | Override `$DIRECT_ADDRESS:port` with URL for Web UI |

See the base environment variables [here](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) for more configuration options.

### Additional Python Environments

| Environment    | Packages |
| -------------- | ----------------------------------------- |
| `reforge`      | SD WebUI reForge and dependencies |

This environment will be activated on shell login.

~~See the base micromamba environments [here](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software#installed-micromamba-environments).~~

## Additional Services

The following services will be launched alongside the [default services](https://github.com/ai-dock/base-image/wiki/1.0-Included-Software) provided by the base image.

### Stable Diffusion WebUI reForge

The service will launch on port `7860` unless you have specified an override with `REFORGE_PORT_HOST`.

You can set startup arguments by using variable `REFORGE_ARGS`.

To manage this service you can use `supervisorctl [start|stop|restart] reforge` or via the Service Portal application.

>[!NOTE]
>All services are password protected by default and HTTPS is available optionally. See the [security](https://github.com/ai-dock/base-image/wiki#security) and [environment variables](https://github.com/ai-dock/base-image/wiki/2.0-Environment-Variables) documentation for more information.

## Pre-Configured Templates

**Vast.​ai**

- None yet.

---

_The author ([@robballantyne](https://github.com/robballantyne)) may be compensated if you sign up to services linked in this document. Testing multiple variants of GPU images in many different environments is both costly and time-consuming; This helps to offset costs
