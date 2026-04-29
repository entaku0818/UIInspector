import UIKit

/// 画面端にスナップするドラッグ可能なフローティングボタン。
final class FloatingButton: UIView {
    var onTap: (() -> Void)?

    private let iconView = UIImageView()
    private var startCenter: CGPoint = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = .systemBlue
        layer.cornerRadius = 26
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)

        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        iconView.image = UIImage(systemName: "magnifyingglass", withConfiguration: config)
        iconView.tintColor = .white
        iconView.contentMode = .center
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragged(_:))))
    }

    @objc private func tapped() { onTap?() }

    @objc private func dragged(_ gesture: UIPanGestureRecognizer) {
        guard let superview else { return }
        switch gesture.state {
        case .began:
            startCenter = center
        case .changed:
            let t = gesture.translation(in: superview)
            center = CGPoint(x: startCenter.x + t.x, y: startCenter.y + t.y)
        case .ended:
            snapToEdge(in: superview)
        default: break
        }
    }

    private func snapToEdge(in superview: UIView) {
        let safe = superview.bounds.inset(by: superview.safeAreaInsets)
        let padding: CGFloat = 16
        let radius: CGFloat = 26
        let newX = center.x < safe.midX ? safe.minX + padding + radius : safe.maxX - padding - radius
        let newY = min(max(center.y, safe.minY + padding + radius), safe.maxY - padding - radius)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0) {
            self.center = CGPoint(x: newX, y: newY)
        }
    }
}
