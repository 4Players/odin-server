# ODIN Server

![v0.5.17](https://img.shields.io/badge/version-0.5.17-blue?style=for-the-badge)

ODIN is a cross-platform software development kit (SDK) that enables developers to integrate real-time chat technology into multiplayer games, apps and websites.

[Online Documentation](https://www.4players.io/developers/)

This repository provides a collection of scripts and configuration files for running an on-premise ODIN server. The ODIN server is a Selective Forwarding Unit (SFU), which connects users in mutual rooms by acting as a relay for media and data.

```mermaid
flowchart BT
  subgraph Server
    R2("Room #quot;Team 1#quot;")
    R1("Room #quot;World Map#quot;")
    R3("Room #quot;Team 2#quot;")
  end

  C1("Client 1")
  C2("Client 2")
  C3("Client 3")
  C4("Client 4")

  C1 --> R1 & R2
  C2 --> R1 & R2
  C3 --> R1 & R3
  C4 --> R1 & R3
```

## Configuration

The server is configured using a configuration file and optional command-line arguments.

**Note:** For local testing, using [mkcert][mkcert] is recommended to generate certificates.


### Command-Line arguments

| Option      | Description              | Default Value  | 
| :---------- | :----------------------- | :------------- |
| `--config`  | Path to the config file  | `config.toml`  |
| `--license` | Path to the license file | `license.toml` |

Here's an example on how to start the server using a custom config path.

```bash
./grid --config /etc/grid/config.toml
```


### The `config.toml` file

You can change the behavior of your ODIN server by modifying its configuration file called `config.toml`, which uses the [TOML][toml] format.


#### `verbosity`

The verbosity level `[0-3]` to define how much information should be written to logs.

```toml
verbosity = 1
```

#### `public_address` <sub><sup>*Required*</sub></sup>

The FQDN and port number where the server can be reached from the Internet.

```toml
public_address = "localhost:4433"
```


### The `[supervisor]` section

The `[supervisor]` section allows you to attach your server instance to an external [gateway][odin-gateway-url], which can be used for scalability in your hosting infrastructure. It is expected to be specified on the root level.

#### `url` <sub><sup>*Required*</sub></sup>

The full web address of the supervisor to contact and send reports to.

```toml
url = "http://localhost:7000/internal"
```


#### `report_interval`

The time in milliseconds between consecutive reports to the supervisor.

```toml
report_interval = 5_000
```

#### `no_warmup`

When true, the server wait for one report cycle before starting to send reports to the supervisor.

```toml
no_warmup = false
```

#### `version`

A freely pickable number to send with reports. This is currently unused, but reserved for future usage.

```toml
version = 123456
```


### The `[authorization]` section

The ODIN server uses JSON Web Tokens (JWT) with EdDSA/Ed25519 signature for client authorization. The `[authorization]` section can be used to change the behavior of this process.

#### `allow_unsigned`

Then true, the server will accept logins using unsigned tokens. It is strongly recommended, that you do **NOT** enable this in a production environment.

```toml
allow_unsigned = false
```

#### `leeway`

The number of milliseconds a login token can be before or beyond its valid time period and still pass.

```toml
leeway = 5_000
```


### The `[[authorization.keys]]` section

The `[[authorization.keys]]` section is used to define a list of keys allowed to sign login tokens. When using a `[supervisor]`, this section can be omitted as it will be automatically generated by the [gateway][odin-gateway-url].

```toml
[[authorization.keys]]
kid = "Afkwfu4BVHDh"
kty = "OKP"
crv = "Ed25519"
x = "a5J2bhmU7vsY0LrW1zt56iUdmhRUNz7Pl9eBoCy29d8"
d = "5FYw1qdABjE0qEKEe821L7UPl_DZfO-PavpaiLsGDR0"
```

**Note:** You can use the [@4players/odin-cli][odin-cli-url] package to generate this section for you.


### The `[quic]` section

The `[quic]` section is used to enable and configure the HTTP/3 socket listener for native ODIN core SDK clients.

#### `binding` <sub><sup>*Required*</sub></sup>

The socket where incoming connections are accepted from. 

```toml
binding = "0.0.0.0:4433"
```

#### `certificate_file` <sub><sup>*Required*</sub></sup>

The path to a PEM-encoded leaf certificate followed by optional intermediate certificates.

```toml
certificate_file = "fullchain.pem"
```

#### `privatekey_file` <sub><sup>*Required*</sub></sup>

The path to a PEM-encoded private key.

```toml
privatekey_file = "privkey.pem"
```

#### `migration`

When enabled, the server accept IP address changes from clients.

```toml
migration = true
```

#### `keep_alive_interval`

Time in milliseconds between keep-alive packets sent by the server.

```toml
keep_alive_interval = 5_000 # ms
```

#### `idle_timeout`

Drop a connection if no packets have been received in this time span in milliseconds.

```toml
idle_timeout = 30_000 # ms
```

#### `pre_send_timeout`

The maximum time the sender waits for a packet to be inserted into the send buffer.

```toml
pre_send_timeout = 500 # ms
```

#### `connect_timeout`

The maximum time in milliseconds a connection can take to finish the HTTP/3 setup, until a client is created.

```toml
connect_timeout = 1_000 # ms
```

#### `no_peers_timeout`

The maximum time in milliseconds a client can stay connected, after leaving all rooms.

```toml
no_peers_timeout = 1_000 # ms
```

#### `max_parallel_connects`

The maximum number of connections that can be in a HTTP/3 connection setup at the same time.

```toml
max_parallel_connects = 50
```


### The `[http]` section

The `[http]` section is used to enable and configure the socket listener for ODIN web SDK clients.

#### `binding` <sub><sup>*Required*</sub></sup>

The socket where incoming connections are accepted from. 

```toml
binding = "0.0.0.0:4433"
```

#### `certificate_file` <sub><sup>*Required*</sub></sup>

The path to a PEM-encoded leaf certificate followed by optional intermediate certificates.

```toml
certificate_file = "fullchain.pem"
```

#### `privatekey_file` <sub><sup>*Required*</sub></sup>

The path to a PEM-encoded private key.

```toml
privatekey_file = "privkey.pem"
```

#### `webrtc_candidates`

The list of IP addresses to be offered as candidates.

```toml
webrtc_candidates = ["127.0.0.1", "::1"]
```

#### `webrtc_ports`

The port range reserved for WebRTC connections.

```toml
webrtc_ports = {begin = 5000, end = 6000}
```

#### `timeout`

Drop connections after this much inactivity in milliseconds.

```toml
timeout = 10_000 # ms
```

#### `ping_interval`

Send a ping to the client using this interval in milliseconds.

```toml
ping_interval = 5_000 # ms
```


### The `[metrics]` section

The `[metrics]` section is used to enable and configure a [Prometheus][prometheus] metrics listener.

#### `binding` <sub><sup>*Required*</sub></sup>

The socket where incoming connections are accepted from. 

```toml
binding = "0.0.0.0:9000"
```

#### `idle_timeout`

How long after the last change a metric value is reported.

```toml
idle_timeout = 3_600_000 # ms
```

#### `global_labels`

Labels that are added to all reported metrics.

```toml
global_labels = {deployment = "foo"}
```

#### `allowed`

List of IP subnets that are allowed to query metrics from the server.

```toml
allowed = ["0.0.0.0/0"]
```


### The `[limit]` section

The `[limit]` section is used to configure concurrency limits.

#### `max_clients`

The maximum number of concurrent clients accepted by the server.

```toml
max_clients = 25
```

#### `max_rooms`

The maximum number of concurrent rooms accepted by the server.

```toml
max_rooms = 25
```

#### `max_peers`

The maximum number of concurrent peers accepted by the server.

```toml
max_peers = 25
```


### The `[limit.network]` section

The `[limit.network]` section is used to configure network rate limits.

#### `incoming_media_packets`

The number of packets a media can send to the server every second.

```toml
incoming_media_packets = {rate = 50, capacity = 100}
```


### The `[limit.peer]` section

The `[limit.peer]` section is used to configure limits per individual peer.

#### `incoming_messages`

The number of command packets of a peer that are processed by the server every second.

```toml
incoming_messages = {rate = 10, capacity = 50, overflow = 20}
```

#### `medias`

The number of medias a peer can create.

```toml
medias = 5
```


### The `[telemetry]` section

The `[telemetry]` section is used to enable a telemetry client used for licensing.

#### `address` <sub><sup>*Required*</sub></sup>

The web address of the telemetry server to contact and send reports to.

```toml
address = "http://localhost/"
```

#### `interval`

The interval in milliseconds how often the telemetry data is being sent.

```toml
interval = 5_000 # ms
```

#### `max_consecutive_failures`

When set, this defines the maximum number of times sending telemetry data can fail before the server shuts down.

```toml
max_consecutive_failures = 4
```

#### `data`

Data from the `[license]` section to send to the telemetry server.

```toml
data = ["LicenseValidUntil", "LicenseLicensee", "LicenseSerialNumber", "LicenseIssuer"]
```


### The `[license]` section

The optional `[license]` section is used to indentify the licensee of the ODIN server. This section is used in a separate `license.toml` file.

#### `signature` <sub><sup>*Required*</sub></sup>

The signature of the license used to verify its validility.

```toml
signature = ""
```

#### `issuer`

An optional field to identify the issuer of the license.

```toml
issuer = "4Players"
```

#### `licensee`

An optional field to identify the licensee. Usually, this is your 4Players customer number (CID).

```toml
licensee = "622012345"
```

#### `serial_number`

An optional serial number of the license. Usually, this is the ID of your on-premise hosting subscription project.

```toml
serial_number = "b0FBTWZ2Rj3OY25uZWtYRlpoekVBUT09"
```

#### `valid_until`

An optional expiration date for the license. When set, the server can't be used after his date.

```toml
valid_until = 1987-07-05T17:45:00Z
```


### The `[internal]` section

The `[limit.peer]` section is used to configure internal settings for debugging.

#### `log_hanging_api_calls`

A debug option to emit warnings if RPC calls take longer then the threshold in milliseconds.

```toml
log_hanging_api_calls = 1_000 # ms
```


## Examples

Create a configuration file and use the `grid` executable to start the ODIN server.

### Minimal `config.toml` for Supervised Server

When running the ODIN server in combination with a [gateway][odin-gateway-url], you only need to specify the web address of the supervisor. The server will register with the supervisor and automatically receive recommended settings, which will be used to extend the local `config.toml` file.

The recommended configuration of the gateway can be defined [here][odin-gateway-config-url].

```toml
[supervisor]
url = "http://localhost:7000/internal"
```

### Minimal `config.toml` for Standalone Server

When running the ODIN server in standalone mode, you need to specify at least one JWK used for authorization pair as well as the binding and certificate configuration for incoming client connections.

```toml
[[authorization.keys]]
kid = "Afkwfu4BVHDh"
kty = "OKP"
crv = "Ed25519"
x = "a5J2bhmU7vsY0LrW1zt56iUdmhRUNz7Pl9eBoCy29d8"
d = "5FYw1qdABjE0qEKEe821L7UPl_DZfO-PavpaiLsGDR0"

[quic]
binding = "0.0.0.0:4433"
certificate_file = "fullchain.pem"
privatekey_file = "privkey.pem"

[http]
binding = "0.0.0.0:4433"
certificate_file = "fullchain.pem"
privatekey_file = "privkey.pem"
```


## Troubleshooting

Contact us through the listed methods below to receive answers to your questions and learn more about ODIN.

### Discord

Join our official Discord server to chat with us directly and become a part of the 4Players ODIN community.

[![Join us on Discord](https://www.4players.io/images/join_discord.png)](https://discord.gg/9yzdJNUGZS)

### Twitter

Have a quick question? Tweet us at [@4PlayersBiz](https://twitter.com/4PlayersBiz) and we’ll help you resolve any issues.

### Email

Don’t use Discord or Twitter? Send us an [email](mailto:odin@4players.io) and we’ll get back to you as soon as possible.


[toml]: https://github.com/toml-lang/toml
[mkcert]: https://github.com/FiloSottile/mkcert
[prometheus]: https://prometheus.io
[odin-cli-url]: https://www.npmjs.com/package/@4players/odin-cli
[odin-gateway-url]: https://github.com/4Players/odin-gateway
[odin-gateway-config-url]: https://github.com/4Players/odin-gateway/blob/main/gridConfigGenerator.ts#L4
