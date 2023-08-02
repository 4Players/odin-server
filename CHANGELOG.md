# Changelog

All notable changes to this project will be documented in this file.

## 1.0.0 🎉

- Added support for WebRTC video streams
- Added new `PauseMedia` and `ResumeMedia` RPC calls to pause/resume receiving of data for a specific media stream
- Added optional Redis database backend to store room/peer state information
- Added `no_peers_timeout` setting for `http` configs to set maximum time a client can stay connected, after leaving all rooms
- Added optional `filters` setting for `log` configs to prevent unnecessary noise
- Added new options specific to terminal logging
- Added new options to allow using external Grafana Loki log aggregation systems
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
