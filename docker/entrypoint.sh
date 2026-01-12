#! /bin/sh

set -e

if [ "$1" = "grid" ]; then
  set -- "$@" --license=/data/license.toml
fi

if [ -f "/data/config.toml" ]; then
  cp -f "/data/config.toml" "${GRID_HOME}/config.toml"
else
  cat << EOF | sed "s/^[ \t]*//;s/[ \t]*$//;/^$/d" > "${GRID_HOME}/config.toml"
      ${GRID_PUBLIC_ADDRESS:+public_address = \"${GRID_PUBLIC_ADDRESS}\"}

      [log.terminal]
      verbosity = ${GRID_LOG_VERBOSITY:-0}
      format = "${GRID_LOG_FORMAT:-text}"
      ${GRID_LOG_FILTERS:+filters = [ ${GRID_LOG_FILTERS} ]}

      ${GRID_LOG_LOKI_URL:+
        [log.loki]
        url = \"${GRID_LOG_LOKI_URL}\"
        ${GRID_LOG_LOKI_LABELS:+labels = ${GRID_LOG_LOKI_LABELS}}
      }

      ${GRID_PROVISIONING_URL:+
        [provisioning]
        url = \"${GRID_PROVISIONING_URL}\"
      }

      ${GRID_DATABASE_URL:+
        [database]
        url = \"${GRID_DATABASE_URL}\"
        ${GRID_DATABASE_USERNAME:+username = \"${GRID_DATABASE_USERNAME}\"}
        ${GRID_DATABASE_PASSWORD:+password = \"${GRID_DATABASE_PASSWORD}\"}
        ${GRID_DATABASE_SERVER_ID:+server_id = \"${GRID_DATABASE_SERVER_ID}\"}
        ${GRID_DATABASE_CONNECT_TIMEOUT:+connect_timeout = ${GRID_DATABASE_CONNECT_TIMEOUT}}
        ${GRID_DATABASE_COMMAND_TIMEOUT:+command_timeout = ${GRID_DATABASE_COMMAND_TIMEOUT}}
      }

      ${GRID_DATABASE_EXPORT_INTERVAL:+
        [database.export]
        interval = ${GRID_DATABASE_EXPORT_INTERVAL}
        ${distinct_customer_precision:+distinct_customer_precision = [ ${GRID_DATABASE_EXPORT_DISTINCT_CUSTOMER_PRECISION} ]}
      }

      ${GRID_DATABASE_REPORT_INTERVAL:+
        [database.report]
        interval = ${GRID_DATABASE_REPORT_INTERVAL}
        ${GRID_DATABASE_REPORT_TAGS:+tags = [ ${GRID_DATABASE_REPORT_TAGS} ]}
      }

      [authorization]
      ${GRID_AUTHORIZATION_LEEWAY:+leeway = ${GRID_AUTHORIZATION_LEEWAY}}
      allow_unsigned = ${GRID_AUTHORIZATION_ALLOW_UNSIGNED:-false}
      keys = [ ${GRID_AUTHORIZATION_KEYS} ]

      [quic]
      binding = "0.0.0.0:${GRID_QUIC_PORT:-4433}"
      certificate_file = "${GRID_CERTIFICATE_FILE:-/data/fullchain.pem}"
      privatekey_file = "${GRID_PRIVATE_KEY_FILE:-/data/privkey.pem}"
      ${GRID_QUIC_NO_PEERS_TIMEOUT:+no_peers_timeout = ${GRID_QUIC_NO_PEERS_TIMEOUT}}
      ${GRID_QUIC_KEEP_ALIVE_INTERVAL:+keep_alive_interval = ${GRID_QUIC_KEEP_ALIVE_INTERVAL}}
      ${GRID_QUIC_CONNECT_TIMEOUT:+connect_timeout = ${GRID_QUIC_CONNECT_TIMEOUT}}
      ${GRID_QUIC_PRE_SEND_TIMEOUT:+pre_send_timeout = ${GRID_QUIC_PRE_SEND_TIMEOUT}}
      ${GRID_QUIC_IDLE_TIMEOUT:+idle_timeout = ${GRID_QUIC_IDLE_TIMEOUT}}
      ${GRID_QUIC_MIGRATION:+migration = ${GRID_QUIC_MIGRATION}}

      [http]
      binding = "0.0.0.0:${GRID_HTTP_PORT:-4433}"
      certificate_file = "${GRID_CERTIFICATE_FILE:-/data/fullchain.pem}"
      privatekey_file = "${GRID_PRIVATE_KEY_FILE:-/data/privkey.pem}"
      webrtc_binding = "0.0.0.0:${GRID_HTTP_WEBRTC_PORT:-8844}"
      ${GRID_HTTP_WEBRTC_CANDIDATES:+webrtc_candidates = [ ${GRID_HTTP_WEBRTC_CANDIDATES} ]}
      ${GRID_HTTP_WEBRTC_ENFORCE_TCP:+webrtc_enforce_tcp = ${GRID_HTTP_WEBRTC_ENFORCE_TCP}}
      ${GRID_HTTP_NO_PEERS_TIMEOUT:+no_peers_timeout = ${GRID_HTTP_NO_PEERS_TIMEOUT}}
      ${GRID_HTTP_PING_INTERVAL:+ping_interval = ${GRID_HTTP_PING_INTERVAL}}
      ${GRID_HTTP_TIMEOUT:+timeout = ${GRID_HTTP_TIMEOUT}}

      ${GRID_HTTP_CLIENT_ADDRESS:+
        [http_client]
        address = \"${GRID_HTTP_CLIENT_ADDRESS}\"
        ${GRID_HTTP_CLIENT_ACCEPT_INVALID_CERTIFICATES:+accept_invalid_certificates = ${GRID_HTTP_CLIENT_ACCEPT_INVALID_CERTIFICATES}}
        ${GRID_HTTP_CLIENT_ACCEPT_INVALID_HOSTNAMES:+accept_invalid_hostnames = ${GRID_HTTP_CLIENT_ACCEPT_INVALID_HOSTNAMES}}
      }

      [limit.peer]
      medias = ${GRID_LIMIT_PEER_MEDIAS:-5}
      ${GRID_LIMIT_CONCURRENT_STREAMS:+concurrent_streams = ${GRID_LIMIT_CONCURRENT_STREAMS}}
      ${GRID_LIMIT_PEER_INCOMING_MESSAGES:+incoming_messages = ${GRID_LIMIT_PEER_INCOMING_MESSAGES}}

      [metrics]
      binding = "0.0.0.0:${GRID_METRICS_PORT:-9000}"
      allowed = ["0.0.0.0/0"]
      global_labels = { deployment = "${GRID_DEPLOYMENT:-docker}", server = "${GRID_PUBLIC_ADDRESS}" }
      ${GRID_METRICS_SYSTEM_UPDATE_INTERVAL:+system_update_interval = ${GRID_METRICS_SYSTEM_UPDATE_INTERVAL}}
      ${GRID_METRICS_IDLE_TIMEOUT:+idle_timeout = ${GRID_METRICS_IDLE_TIMEOUT}}

      [internal]
      log_rejected_api_calls = ${GRID_INTERNAL_LOG_REJECTED_API_CALLS:-false}
      ${GRID_INTERNAL_LOG_HANGING_API_CALLS:+log_hanging_api_calls = ${GRID_INTERNAL_LOG_HANGING_API_CALLS}}
      ${GRID_INTERNAL_BUNDLE_EVENTS:+bundle_events = ${GRID_INTERNAL_BUNDLE_EVENTS}}

EOF
fi

exec "$@"
