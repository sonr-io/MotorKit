# MotorKit for Swift
> Apple architecture (iOS, macOS) bindings for the Sonr Motor Node.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![codebeat-badge][codebeat-image]][codebeat-url]

These methods are subject to change, as the library is being actively developed.

| **Method**         | **Description**                                                              |        **Params**        | **Returns** |
|--------------------|------------------------------------------------------------------------------|:------------------------:|:-----------:|
| `NewWallet`        | Create a new mpc wallet                                                      |      Threshold:`int`     |    ERROR    |
| `ExportWallet`     | Marshals wallet to json and returns - TESTING ONLY                           |                          |    BYTES    |
| `LoadWallet`       | Unmarshals the buffer into a wallet                                          |       Buf: `bytes`       |    ERROR    |
| `Address`          | Get wallet address                                                           |                          |    STRING   |
| `DidDoc`           | Get DidDocument of account                                                   |                          |    STRING   |
| `ImportCredential` | Import a webauthn/biometric credential proto bytes into wallet did document  |       Cred:`bytes`       |    ERROR    |
| `Sign`             | Sign a buffer with MPC wallet, completes entire process and returns a tx raw |        Msg:`bytes`       |    BYTES    |
| `Verify`           | Verify a signature of a buffer                                               | Msg:`bytes`, Sig:`bytes` |     BOOL    |


## Installation

Add this project on your `Package.swift`

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/sonr-io/MotorKit.git", majorVersion: 0, minor: 4)
    ]
)
```

## Usage example


```swift
import MotorKit

let res = MotorKit.createAccount("super-secret-pasword", aesDscKey)
```


## Development setup

Describe how to install all development dependencies and how to run an automated test-suite of some kind. Potentially do this for multiple platforms.

```sh
make install
```

## To Do
- [ ] Implement ExportWallet in Swift/Java/JS
- [ ] Implement LoadWallet in Swift/Java/JS
- [ ] Implement Address in Swift/Java/JS
- [ ] Implement DidDoc in Swift/Java/JS
- [ ] Implement ImportCredential in Swift/Java/JS
- [ ] Implement Sign in Swift/Java/JS
- [ ] Implement Verify in Swift/Java/JS

## Meta

Sonr – [@sonr_io](https://twitter.com/sonr_io) – team@sonr.io

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/yourname/github-link](https://github.com/dbader/)

[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
