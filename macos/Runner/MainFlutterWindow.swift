import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}

# touched on 2025-05-28T20:50:32.166391Z
# touched on 2025-05-28T20:51:26.419532Z
# touched on 2025-05-28T20:51:44.283606Z
# touched on 2025-05-28T20:53:22.581716Z