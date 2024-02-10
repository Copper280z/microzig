![MicroZig Logo](design/logo-text-auto.svg)

[![Continuous Integration](https://github.com/ZigEmbeddedGroup/microzig-monorepo/actions/workflows/build.yml/badge.svg)](https://github.com/ZigEmbeddedGroup/microzig-monorepo/actions/workflows/build.yml)

## Overview

- `build/` contains the build components of MicroZig.
- `core/` contains the shared components of MicroZig.
- `board-support/` contains all official board support package.
- `examples/` contains examples that can be used with the board support packages.
- `tools/` contains tooling to work *on* MicroZig itself, so deployment, testing, ...

## Versioning Scheme

MicroZig versions are tightly locked with Zig versions.

The general scheme is `${zig_version}-${commit}-${count}`, so the MicroZig versions will look really similar to
Zigs versions, but with our own commit abbreviations and counters.

As MicroZig sticks to tagged Zig releases, `${zig_version}` will show to which Zig version the MicroZig build is compatible.

Consider the version `0.11.0-abcdef-123` means that this MicroZig version has a commit starting with `abcdef`, which was the 123rd commit of the version that is compatible with Zig 0.11.0.

## TODO (before exchanging upstream)

- Integrate https://github.com/ZigEmbeddedGroup/microzig-driver-framework as package
- Create support for nice GitHub badges
- validate that the table on https://github.com/ZigEmbeddedGroup is correct (in CI)
- start porting everything to 0.12/unstable
- Try to get some autodocs to build.
