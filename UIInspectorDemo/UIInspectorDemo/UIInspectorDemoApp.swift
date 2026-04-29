import SwiftUI
import UIInspector

@main
struct UIInspectorDemoApp: App {
    init() {
        UIInspector.shared.install()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
