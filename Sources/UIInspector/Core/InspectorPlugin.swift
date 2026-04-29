import UIKit

/// UIInspector に機能を追加するプラグインプロトコル。
@MainActor
public protocol InspectorPlugin: AnyObject {
    /// 逆ドメイン形式の一意識別子。
    var id: String { get }
    /// プラグインメニューに表示する名前。
    var name: String { get }
    /// SF Symbols のアイコン名。
    var iconName: String { get }
    /// プラグインメニューに表示する説明。
    var pluginDescription: String { get }

    /// ユーザーがプラグインを選択したときに呼ばれる。
    func activate(context: any InspectorContext)
    /// 別のプラグインへ切替またはインスペクタ終了時に呼ばれる。
    func deactivate()
}
