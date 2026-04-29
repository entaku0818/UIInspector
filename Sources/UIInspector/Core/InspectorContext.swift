import UIKit

/// プラグインがインスペクタ基盤にアクセスするためのインターフェース。
@MainActor
public protocol InspectorContext: AnyObject {
    /// アプリのメインウィンドウ（インスペクタウィンドウ以外）。
    var appWindow: UIWindow? { get }

    /// ビュー選択モードを開始する。次のタップで選択されたビューが返る。
    func startViewSelection(onSelect: @escaping @MainActor (UIView) -> Void)

    /// ビュー選択モードをキャンセルする。
    func stopViewSelection()

    /// 指定したビューにカラーボーダーのハイライトを描画する。
    @discardableResult
    func highlight(view: UIView, color: UIColor, label: String?) -> HighlightToken

    /// 指定トークンのハイライトを削除する。
    func removeHighlight(_ token: HighlightToken)

    /// 全ハイライトを削除する。
    func clearHighlights()

    /// ボトムシートパネルとして UIViewController を表示する。
    func presentPanel(_ viewController: UIViewController, animated: Bool)

    /// パネルを閉じる。
    func dismissPanel(animated: Bool)
}

/// `highlight(view:color:label:)` が返すトークン。特定ハイライトの削除に使う。
public final class HighlightToken {
    let overlayView: UIView
    init(overlayView: UIView) { self.overlayView = overlayView }
}
