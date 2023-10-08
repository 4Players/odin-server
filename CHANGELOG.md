# Changelog

All notable changes to this project will be documented in this file.

## 1.3.1

- Fixed a bug where instance properties were not deleted from [Redis](https://redis.io) database backend on room close

## 1.3.0 📦

- Enhanced `telemetry` config with optional fields for server usage reporting
- Refined position-based packet culling for 3D coordinate support
- Updated Redis database structure

## 1.2.2

- Restored legacy 1.x client compatibility for `MediaStarted` events

## 1.2.1

- Introduced `use_tls`, `username`, and `password` settings to `database` config
- Resolved duplicate HTTP basic auth headers in supervisor URLs

## 1.2.0

- Introduced terminal-specific `colors` setting in `log` config
- Added `http_client` config for proxy server setup in outbound HTTP requests
- Included debug option for logging rejected RPC calls
- Renamed `allow_unknown_server_certificates` to `accept_invalid_certificates`, relocated to new `http_client` config
- Refined logging to maintain external log aggregation integrity regardless of verbosity filters
- Enhanced logging and error handling for outbound telemetry requests on on-premise servers
- Fixed client re-entry issue on the same QUIC connection to a second room
- Fixed incorrect per customer RPC usage counting

## 1.1.0

- Added per customer RPC usage information to metrics
- Added optional `allow_unknown_server_certificates` setting to `telemetry` configs
- Improved logging for scenarios when incoming QUIC connections fail
- Adjusted the maximum datagram size for QUIC connections

## 1.0.0 🎉

- Added support for WebRTC video streams
- Added new `PauseMedia` and `ResumeMedia` RPC calls to pause/resume receiving of data for a specific media stream
- Added optional [Redis](https://redis.io) database backend to store room/peer state information
- Added `no_peers_timeout` setting for `http` configs to set maximum time a client can stay connected, after leaving all rooms
- Added optional `filters` setting for `log` configs to prevent unnecessary noise
- Added new options specific to terminal logging
- Added new options to allow using external [Grafana Loki](https://grafana.com/oss/loki/) log aggregation systems
- Updated `Authenticate` RPC calls to be deprecated
- Updated Dockerfiles to support the new config format
- Removed unused `version` setting from `supervisor` configs
- Replaced [libdatachannel](https://libdatachannel.org) with [webrtc-rs](https://webrtc.rs)
- Refactored and reorganized codebase for improved reliability and performance

## 0.5.23

- Added per customer `billing_voice_incoming_bytes` and `billing_voice_outgoing_bytes` to metrics
- Added log message when server is starting with no client listener configured

## 0.5.22

- Fixed a bug where subsequent `Authenticate` RPC calls would fail

## 0.5.21

- Added forward compatibility to support new client versions
- Added `public_address_override` setting for `quic` and `http` configs to allow specifying individual public endpoints per protocol if needed

## 0.5.20

- Added server version to supervisor `sfu.Report` requests

## 0.5.19

- Added support for multiplexed connections on the same UDP port for web clients
- Removed `max_parallel_connects` setting for QUIC connections

## 0.5.18

- Added support for HTTP authentication ([RFC 7235](https://datatracker.ietf.org/doc/html/rfc7235)) in supervisor `url` option
- Changed deployment target for macOS to 10.13

## 0.5.17

- Initial public release
