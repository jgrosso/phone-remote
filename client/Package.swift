// swift-tools-version:3.1

import PackageDescription

let package = Package(
  name: "PhoneRemoteClient",
  dependencies: [
    .Package(url: "https://github.com/socketio/socket.io-client-swift", majorVersion: 11)
  ]
)
