# ODIN Server Docker Images

These Dockerfiles can be used build Docker images to launch the ODIN server in an isolated and lightweight environment, which includes all necessary dependencies.

## Volumes

By default, the images expect a single volume, located at `/data`, that will hold:

* a server configuration file (`config.toml`)
* a server license file (`license.toml`)
* a PEM-encoded certificate file (`fullchain.pem`)
* a PEM-encoded private key file (`fullchain.pem`)

### Auto-Generating a Configuration File

If no configuration file is found in `/data`, the image will try to auto-generate a minimal `config.toml` using environment variables.

The following environment variables are supported:

* `GRID_PUBLIC_ADDRESS` (mandatory): The FQDN and port number where the server can be reached from the Internet
* `GRID_SUPERVISOR_URL` (mandatory): The full web address of the supervisor to contact and send reports to
* `GRID_CERTIFICATE_FILE`: The path to a PEM-encoded leaf certificate followed by optional intermediate certificates.
* `GRID_PRIVATE_KEY_FILE`: The path to a PEM-encoded leaf certificate followed by optional intermediate certificates.
* `GRID_VERBOSITY`: The verbosity level `0-3` to define how much information should be written to logs.
* `GRID_DEPLOYMENT`: Deployment labels that are added to all reported metrics.
