# MahaRouteCore

`MahaRouteCore` is a lightweight routing core extracted from `MHGlobalRouter` for private pod distribution.

## Structure

- `MahaRouteCore/Classes/MahaRouteCenter.swift`: public routing entrypoint
- `MahaRouteCore/Classes/Config/MahaRouteModel.swift`: route model and enums
- `MahaRouteCore/Classes/Tool/MahaRouteParser.swift`: route parsing helper
- `MahaRouteCore.podspec`: pod definition for private distribution

## Current Behavior

- Uses `mh://` as the default route protocol, but exposes a public configuration entry for the host app
- Preserves full-screen H5, half-screen H5, and native page dispatch branches
- Depends on `MHLog`

## Configuration

```swift
MahaRouteCenter.configure(routeSchemePrefix: "maha://")
```

## Installation

This repository is prepared for private pod distribution through:

- Pod source repo: `https://github.com/wangweiqi864-hue/MaHaSpecs.git`
- Library repo: `https://github.com/wangweiqi864-hue/MahaRouteCore.git`

## Notes

- Prepared from `Maha_/LocalPods/MHGlobalRouter`
- The original app integration is intentionally untouched at this stage

## License

See `LICENSE`.
