# ODIN Server Docker Images

These Dockerfiles can be used build Docker images to launch the ODIN server in an isolated and lightweight environment, which includes all necessary dependencies.

## Volumes

By default, the images expect a single volume, located at `/data`, that will hold:

* a server configuration file (`config.toml`)
* a server license file (`license.toml`)
* a PEM-encoded certificate file (`fullchain.pem`)
* a PEM-encoded private key file (`privkey.pem`)

### Auto-Generating a Configuration File

If no configuration file is found in `/data`, the image will try to auto-generate a `config.toml` using environment variables.

The following environment variables are supported:

* `GRID_PUBLIC_ADDRESS`
* `GRID_CERTIFICATE_FILE`
* `GRID_PRIVATE_KEY_FILE`
* `GRID_DEPLOYMENT`

#### Provisioning Settings

* `GRID_PROVISIONING_URL`

#### QUIC Settings

* `GRID_QUIC_NO_PEERS_TIMEOUT`
* `GRID_QUIC_KEEP_ALIVE_INTERVAL`
* `GRID_QUIC_CONNECT_TIMEOUT`
* `GRID_QUIC_PRE_SEND_TIMEOUT`
* `GRID_QUIC_IDLE_TIMEOUT`
* `GRID_QUIC_MIGRATION`

#### HTTP Settings

* `GRID_HTTP_WEBRTC_CANDIDATES`
* `GRID_HTTP_NO_PEERS_TIMEOUT`
* `GRID_HTTP_PING_INTERVAL`
* `GRID_HTTP_TIMEOUT`

#### Logging Settings

* `GRID_LOG_VERBOSITY`
* `GRID_LOG_FORMAT`
* `GRID_LOG_FILTERS`
* `GRID_LOG_LOKI_URL`
* `GRID_LOG_LOKI_LABELS`

#### Database Settings

* `GRID_DATABASE_URL`
* `GRID_DATABASE_USERNAME`
* `GRID_DATABASE_PASSWORD`
* `GRID_DATABASE_SERVER_ID`
* `GRID_DATABASE_CONNECT_TIMEOUT`
* `GRID_DATABASE_COMMAND_TIMEOUT`
* `GRID_DATABASE_REPORT_INTERVAL`
* `GRID_DATABASE_REPORT_TAGS`

#### Limit Settings

* `GRID_LIMIT_PEER_MEDIAS`
* `GRID_LIMIT_PEER_INCOMING_MESSAGES`
* `GRID_LIMIT_CONCURRENT_STREAMS`

#### Metrics Settings

* `GRID_METRICS_SYSTEM_UPDATE_INTERVAL`
* `GRID_METRICS_IDLE_TIMEOUT`

#### HTTP Proxy Settings

* `GRID_HTTP_CLIENT_ADDRESS`
* `GRID_HTTP_CLIENT_ACCEPT_INVALID_CERTIFICATES`

#### Internal Settings

* `GRID_INTERNAL_LOG_REJECTED_API_CALLS`
* `GRID_INTERNAL_LOG_HANGING_API_CALLS`
