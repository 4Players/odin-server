#! /bin/sh

set -e

if [ "$1" = "grid" ]; then
  set -- "$@" --license=/data/license.toml
fi

if [ -f "/data/config.toml" ]; then
  cp -f "/data/config.toml" "${GRID_HOME}/config.toml"
else
  cat << EOF | sed "s/^[ \t]*//;s/[ \t]*$//;/^$/d" > "${GRID_HOME}/config.toml"
    public_address = "${GRID_PUBLIC_ADDRESS}"

    [log]
    verbosity = ${GRID_VERBOSITY:-0}

    [supervisor]
    url = "${GRID_SUPERVISOR_URL}"

    [quic]
    binding = "0.0.0.0:4433"
    certificate_file = "${GRID_CERTIFICATE_FILE:-/data/fullchain.pem}"
    privatekey_file = "${GRID_PRIVATE_KEY_FILE:-/data/privkey.pem}"

    [http]
    binding = "0.0.0.0:4433"
    certificate_file = "${GRID_CERTIFICATE_FILE:-/data/fullchain.pem}"
    privatekey_file = "${GRID_PRIVATE_KEY_FILE:-/data/privkey.pem}"
    webrtc_binding = "0.0.0.0:5000"

    [metrics]
    binding = "0.0.0.0:9000"
    global_labels = { deployment = "${GRID_DEPLOYMENT:-docker}", server = "${GRID_PUBLIC_ADDRESS}" }
    allowed = ["0.0.0.0/0"]
EOF
fi

exec "$@"
