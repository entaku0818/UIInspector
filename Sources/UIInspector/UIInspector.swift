import UIKit

/// UIInspector – iOS アプリ向けUIデバッグツール。
///
/// Quick start:
/// ```swift
/// // AppDelegate or SwiftUI App.init:
/// #if DEBUG
/// UIInspector.shared.install()
/// #endif
/// ```
@MainActor
public final class UIInspector {
    public static let shared = UIInspector()
    private var manager: InspectorManager?

    private init() {}

    /// インスペクタをインストールする。追加プラグインを渡すことで拡張可能。
    /// Built-in: View Hierarchy / View Attributes / Measure
    public func install(additionalPlugins: [any InspectorPlugin] = []) {
        let defaults: [any InspectorPlugin] = [
            ViewHierarchyPlugin(),
            ViewAttributesPlugin(),
            MeasurePlugin()
        ]
        let mgr = InspectorManager(plugins: defaults + additionalPlugins)
        mgr.setup()
        self.manager = mgr
    }

    /// プログラムからプラグインメニューを開く。
    public func show() {
        manager?.showPluginMenu()
    }

    /// インスペクタを閉じる。
    public func hide() {
        manager?.deactivate()
    }
}
