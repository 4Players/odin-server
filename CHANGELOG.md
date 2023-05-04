# Changelog

All notable changes to this project will be documented in this file.

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
