import UIKit

/// 選択されたビューの上に描画するハイライトオーバーレイ。
final class HighlightView: UIView {
    var borderColor: UIColor = .systemBlue { didSet { setNeedsDisplay() } }
    var labelText: String? { didSet { label.text = labelText; label.isHidden = labelText == nil } }

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame.insetBy(dx: -1, dy: -1))
        backgroundColor = .clear
        isUserInteractionEnabled = false

        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: topAnchor, constant: -2),
            label.heightAnchor.constraint(equalToConstant: 16),
            label.widthAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])
    }

    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        ctx.setFillColor(borderColor.withAlphaComponent(0.12).cgColor)
        ctx.fill(rect)
        ctx.setStrokeColor(borderColor.cgColor)
        ctx.setLineWidth(2)
        ctx.stroke(rect.insetBy(dx: 1, dy: 1))
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.backgroundColor = borderColor
    }
}
