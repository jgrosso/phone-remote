import Cocoa
import SocketIO

let socket = SocketIOClient(
  socketURL: URL(string: "http://localhost:3000")!,
  config: [.log(true), .compress]
)

func emitCurrentApplication() {
  if let currentApplication = NSWorkspace.shared().frontmostApplication?.localizedName {
    socket.emit("current-application", currentApplication)
  }
}

socket.on(clientEvent: .connect) { data, ack in
  print("Connected!")
}
socket.on("request-application") { data, ack in
  print("request-application received!")

  emitCurrentApplication()
}
socket.on("run-shortcut") { data, ack in
  print("run-shortcut received!")

  let script = "tell application \"System Events\" to keystroke \(data[0])"
  if let script = NSAppleScript(source: script) {
    var error: NSDictionary?
    script.executeAndReturnError(&error)
  }
}
socket.connect()

class CurrentApplicationChangedObserver: NSObject {
  override init() {
    super.init()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(currentApplicationChanged),
      name: .NSWorkspaceDidActivateApplication,
      object: nil
    )
  }

  func currentApplicationChanged() {
    print("Current application changed!")
    emitCurrentApplication()
  }
}
CurrentApplicationChangedObserver()

RunLoop.main.run()
