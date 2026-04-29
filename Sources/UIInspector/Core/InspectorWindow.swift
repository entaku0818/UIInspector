import UIKit

final class InspectorWindow: UIWindow {
    weak var manager: InspectorManager?
    private(set) var floatingButton: FloatingButton?

    func setup() {
        backgroundColor = .clear
        windowLevel = .statusBar + 1
        isHidden = false

        let rootVC = PassthroughViewController()
        rootVC.view.backgroundColor = .clear
        rootViewController = rootVC

        addFloatingButton(to: rootVC.view)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShake),
            name: .inspectorShakeDetected,
            object: nil
        )
    }

    private func addFloatingButton(to view: UIView) {
        let btn = FloatingButton(frame: CGRect(
            x: UIScreen.main.bounds.width - 72,
            y: UIScreen.main.bounds.height - 130,
            width: 52, height: 52
        ))
        btn.onTap = { [weak self] in self?.manager?.showPluginMenu() }
        view.addSubview(btn)
        floatingButton = btn
    }

    @objc private func handleShake() {
        manager?.showPluginMenu()
    }
}
