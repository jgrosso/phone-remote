//
//  ViewController.swift
//  client
//
//  Created by Josh Grosso on 9/13/17.
//  Copyright © 2017 Joshua Grosso. All rights reserved.
//

import Cocoa
import SocketIO

class ViewController: NSViewController {
  required init?(coder: NSCoder) {
    super.init(coder: coder)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(currentApplicationChanged),
      name: .NSWorkspaceDidActivateApplication,
      object: nil
    )
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  private var socket: SocketIOClient!

  @objc private func currentApplicationChanged() {
    print("Current application changed!")
    emitCurrentApplication()
  }

  private func emitCurrentApplication() {
    if let currentApplication = NSWorkspace.shared().frontmostApplication?.localizedName {
      socket.emit("current-application", currentApplication)
    }
  }

  private func runScript(_ source: String) {
    if let script = NSAppleScript(source: source) {
      var error: NSDictionary?
      script.executeAndReturnError(&error)
    }
  }

  override func viewDidLoad() {
    socket = SocketIOClient(
      socketURL: URL(string: "http://localhost:3000")!,
      config: [.log(true), .compress]
    )

    socket.on(clientEvent: .connect) { data, ack in
      print("Connected!")
    }
    socket.on("request-application") { data, ack in
      print("request-application received!")

      self.emitCurrentApplication()
    }
    socket.on("run-shortcut") { data, ack in
      print("run-shortcut received!")

      self.runScript("tell application \"System Events\" to keystroke \(data[0])")
    }
    socket.connect()
  }
}
