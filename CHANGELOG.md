# Changelog

All notable changes to this project will be documented in this file.

## 1.6.4

- Added video usage metrics
- Fixed a bug where configured database backend credentials were ignored
- Readded deprecated `Authenticate` RPC to metrics
- Updated reconnect tokens to contains origin SFU addresses

## 1.6.3

- Fixed a bug related to `server_actions` when polling a terminated stream

## 1.6.2

- Added cleanup procedure for orphan rooms in the database on server startup
- Optimized database handling for better performance
- Added support for VP9, H.264 and AV1 video codecs

## 1.6.1

- Improved `server_actions` with cancellation safety in the database handler

## 1.6.0 🏥

- Refactored database backend to remove dependency on specific Redis functions
- Updated supervisor reports to be stored in the database for multi-gateway scalability
- Separated gateway and provisioning into distinct services
- Added support for tagging during provisioning to enable customer-specific server assignments

## 1.5.15

- Updated Windows dependencies to maintain compatibility with older operating systems lacking support for `ISWow64Process2`
- Updated Alpine Linux base image to version 3.20

## 1.5.14

- Increased gateway request timeout during startup

## 1.5.13

- Fixed an issue that could lead to lingering WebRTC connections in specific scenarios

## 1.5.12

- Fixed a bug where multi-room voice packets could be rejected

## 1.5.11

- Enhanced error messages for invalid or excessive media ID inputs to provide clearer feedback for debugging

## 1.5.10

- Improved audio transmission by implementing backpressure handling to allow dropping stale voice packets during network delays
- Introduced a timeout mechanism to discard voice packets delayed by more than 100ms to optimize real-time audio performance for web clients
- Added a new metric to monitor contention scenarios where sending voice packets requires deferred execution

## 1.5.9

- Fixed a potential issue that could cause web clients to stop receiving voice packets under certain conditions

## 1.5.8

- Added a convenience feature to automatically determine WebRTC candidates using `public_address` when none are configured

## 1.5.7

- Changed default WebRTC binding port from `5000` to `8844`
- Fixed a bug where WebRTC candidate settings were not applied correctly

## 1.5.6

- Updated media packet routing to support clients with E2E encryption enabled

## 1.5.5 🎮

- Updated WebTransport settings to allow PlayStation 5 clients to connect

## 1.5.4

- Fixed a bug where servers in stand-alone mode were unable to start

## 1.5.3

- Fixed a bug where the server provided invalid WebRTC candidates to browser clients using IPv6

## 1.5.2

- Fixed server not shutting down after 300 seconds of failed supervisor reports

## 1.5.1

- Added database health check to supervisor reports
- Removed [Redis](https://redis.io) client-side caching for `server_link_room` to prevent possible ownership fights
- Fixed `room is temporarily not available` errors

## 1.5.0 📍

- Refactored peer position system to no longer use a k-d-tree to improve performance
- Fixed clients not being reaped after disconnecting

## 1.4.3

- Added missing functionality to update existing ban list entries 

## 1.4.2

- Improved logging and error handing when clients try to authenticate with invalid tokens

## 1.4.1

- Fixed a bug where invalid peer coordinates were written to the server logs

## 1.4.0 👨‍💻

- Added support for ODIN server extenders
- Added support for Apple Silicon Macs
- Removed `colors` setting from log config in favor of `NO_COLOR` environment variable
- Reorganized log config for enhanced convenience

## 1.3.10

- Added new `command_timeout` setting to database config to prevent commands from waiting for [Redis](https://redis.io) connection being re-established

## 1.3.9

- Temporarily expanded the QUIC server send window to conduct scalability testing

## 1.3.8

- Fixed a bug where distances for peers that remained in range were not updated when limiting concurrent streams

## 1.3.7

- Fixed a potential crash when updating peer positions by adding a random factor to the coordinates on all axis with epsilon magnitude

## 1.3.6

- Added new `concurrent_streams` setting to peer limit config that allows specifying the maximum number of audio streams each individual peer can receive at the same time

## 1.3.5

- Added code that lowers the amount of allocations when broadcasting packets
- Fixed broken `system_network_tx_bytes` metric
- Ignore `SetPosition` RPC calls if peer is already at target coordinates

## 1.3.4

- Use random instance id when initializing the server to avoid duplicate keys in [Redis](https://redis.io)

## 1.3.3

- Updated k-d-tree bucket size from 32 to 128
- Reject `SetPosition` RPC calls with positions where too many neighbors exist

## 1.3.2

- Updated timeouts for all keys in optional [Redis](https://redis.io) database backend to 7 days
- Fixed a bug where 3D ccordinates were not stored as peer properties in database

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
