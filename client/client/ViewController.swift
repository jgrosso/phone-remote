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
  private var socket: SocketIOClient

  required init?(coder: NSCoder) {
    socket = SocketIOClient(
      socketURL: URL(string: "http://localhost:3000")!,
      config: [.log(true), .compress]
    )

    super.init(coder: coder)

    NSWorkspace.shared().notificationCenter.addObserver(
      self,
      selector: #selector(currentApplicationChanged),
      name: NSNotification.Name.NSWorkspaceDidActivateApplication,
      object: nil
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

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc private func currentApplicationChanged(_ notification: NSNotification) {
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
}
