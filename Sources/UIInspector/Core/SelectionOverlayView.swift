import UIKit

/// タップしたアプリのビューを選択するための全画面透過オーバーレイ。
final class SelectionOverlayView: UIView {
    var onViewSelected: ((UIView) -> Void)?
    weak var appWindow: UIWindow?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = UIColor.systemBlue.withAlphaComponent(0.06)

        let hint = UILabel()
        hint.text = "ビューをタップして選択"
        hint.textAlignment = .center
        hint.font = .systemFont(ofSize: 13, weight: .semibold)
        hint.textColor = .white
        hint.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.85)
        hint.layer.cornerRadius = 10
        hint.layer.masksToBounds = true
        hint.translatesAutoresizingMaskIntoConstraints = false
        addSubview(hint)
        NSLayoutConstraint.activate([
            hint.centerXAnchor.constraint(equalTo: centerXAnchor),
            hint.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            hint.heightAnchor.constraint(equalToConstant: 36),
            hint.widthAnchor.constraint(greaterThanOrEqualToConstant: 180),
            hint.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            hint.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let appWindow else { return }
        // 画面座標（インスペクタウィンドウ座標 = アプリウィンドウ座標）
        let point = gesture.location(in: nil)
        guard let view = findDeepestView(at: point, in: appWindow) else { return }
        onViewSelected?(view)
    }

    // MARK: - View finding

    private func findDeepestView(at windowPoint: CGPoint, in window: UIWindow) -> UIView? {
        for subview in window.subviews.reversed() {
            if let found = deepest(at: windowPoint, in: subview, appWindow: window) {
                return found
            }
        }
        return nil
    }

    private func deepest(at windowPoint: CGPoint, in view: UIView, appWindow: UIWindow) -> UIView? {
        guard !view.isHidden, view.alpha > 0.01 else { return nil }
        let local = appWindow.convert(windowPoint, to: view)
        guard view.bounds.contains(local) else { return nil }
        for subview in view.subviews.reversed() {
            if let found = deepest(at: windowPoint, in: subview, appWindow: appWindow) {
                return found
            }
        }
        return view
    }
}
