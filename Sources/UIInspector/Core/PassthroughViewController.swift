import UIKit

/// インスペクタウィンドウのルートVC。
/// 自身の view へのタッチはアプリのウィンドウへパススルーし、
/// サブビュー（ボタン・オーバーレイ等）へのタッチは通常通り処理する。
final class PassthroughViewController: UIViewController {
    override func loadView() {
        view = PassthroughView()
    }

    override var canBecomeFirstResponder: Bool { true }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        becomeFirstResponder()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard motion == .motionShake else { return }
        NotificationCenter.default.post(name: .inspectorShakeDetected, object: nil)
    }
}

final class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        // self へのヒットは nil を返してアプリウィンドウへパススルー
        return hit === self ? nil : hit
    }
}

extension Notification.Name {
    static let inspectorShakeDetected = Notification.Name("UIInspector.shakeDetected")
}
