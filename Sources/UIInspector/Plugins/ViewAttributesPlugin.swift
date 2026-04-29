import UIKit
import SwiftUI

@MainActor
public final class ViewAttributesPlugin: InspectorPlugin {
    public let id = "com.uiinspector.viewattributes"
    public let name = "View Attributes"
    public let iconName = "list.bullet.rectangle"
    public let pluginDescription = "ビューのプロパティを詳細表示"

    private weak var context: (any InspectorContext)?

    public init() {}

    public func activate(context: any InspectorContext) {
        self.context = context
        startSelection()
    }

    public func deactivate() {
        context?.stopViewSelection()
        context?.clearHighlights()
        context = nil
    }

    private func startSelection() {
        context?.startViewSelection { [weak self] view in
            self?.showAttributes(for: view)
        }
    }

    private func showAttributes(for view: UIView) {
        context?.clearHighlights()
        context?.highlight(view: view, color: .systemGreen, label: nil)

        let attrs = ViewAttributes(view: view)
        let panelView = AttributesPanelView(attributes: attrs) { [weak self] in
            self?.startSelection()
        }
        let hostingVC = UIHostingController(rootView: panelView)
        context?.presentPanel(hostingVC, animated: true)
    }
}

// MARK: - View Attributes Data Model

struct ViewAttributes {
    let className: String
    let frame: CGRect
    let bounds: CGRect
    let backgroundColor: UIColor?
    let alpha: CGFloat
    let isHidden: Bool
    let isUserInteractionEnabled: Bool
    let tag: Int
    let accessibilityIdentifier: String?
    let accessibilityLabel: String?
    let clipsToBounds: Bool
    let cornerRadius: CGFloat
    let typeSpecific: [AttributeRow]

    init(view: UIView) {
        className = String(describing: type(of: view))
        frame = view.frame
        bounds = view.bounds
        backgroundColor = view.backgroundColor
        alpha = view.alpha
        isHidden = view.isHidden
        isUserInteractionEnabled = view.isUserInteractionEnabled
        tag = view.tag
        accessibilityIdentifier = view.accessibilityIdentifier
        accessibilityLabel = view.accessibilityLabel
        clipsToBounds = view.clipsToBounds
        cornerRadius = view.layer.cornerRadius

        var extra: [AttributeRow] = []
        if let label = view as? UILabel {
            extra.append(.init(key: "text", value: label.text ?? "nil"))
            extra.append(.init(key: "font", value: "\(label.font.fontName) \(label.font.pointSize)pt"))
            extra.append(.init(key: "textColor", value: label.textColor.inspectorHex))
            extra.append(.init(key: "numberOfLines", value: "\(label.numberOfLines)"))
            extra.append(.init(key: "alignment", value: label.textAlignment.inspectorDescription))
        } else if let button = view as? UIButton {
            extra.append(.init(key: "title", value: button.title(for: .normal) ?? "nil"))
            extra.append(.init(key: "isEnabled", value: "\(button.isEnabled)"))
        } else if let imageView = view as? UIImageView {
            extra.append(.init(key: "hasImage", value: "\(imageView.image != nil)"))
            extra.append(.init(key: "contentMode", value: imageView.contentMode.inspectorDescription))
        } else if let textField = view as? UITextField {
            extra.append(.init(key: "text", value: textField.text ?? ""))
            extra.append(.init(key: "placeholder", value: textField.placeholder ?? "nil"))
        } else if let textView = view as? UITextView {
            let preview = String((textView.text ?? "").prefix(40))
            extra.append(.init(key: "text", value: preview.isEmpty ? "nil" : preview))
        } else if let scrollView = view as? UIScrollView {
            extra.append(.init(key: "contentOffset", value: scrollView.contentOffset.inspectorDescription))
            extra.append(.init(key: "contentSize", value: scrollView.contentSize.inspectorDescription))
            extra.append(.init(key: "isScrollEnabled", value: "\(scrollView.isScrollEnabled)"))
        }
        typeSpecific = extra
    }
}

struct AttributeRow: Identifiable {
    let id = UUID()
    let key: String
    let value: String
}

// MARK: - UIKit Helpers

private extension UIColor {
    var inspectorHex: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        if a < 1 {
            return String(format: "#%02X%02X%02X %.0f%%", Int(r*255), Int(g*255), Int(b*255), a*100)
        }
        return String(format: "#%02X%02X%02X", Int(r*255), Int(g*255), Int(b*255))
    }
}

extension UIColor {
    var inspectorHexPublic: String { inspectorHex }
}

private extension NSTextAlignment {
    var inspectorDescription: String {
        switch self {
        case .left: return "left"
        case .center: return "center"
        case .right: return "right"
        case .justified: return "justified"
        case .natural: return "natural"
        @unknown default: return "unknown"
        }
    }
}

private extension UIView.ContentMode {
    var inspectorDescription: String {
        switch self {
        case .scaleToFill: return "scaleToFill"
        case .scaleAspectFit: return "scaleAspectFit"
        case .scaleAspectFill: return "scaleAspectFill"
        case .center: return "center"
        case .top: return "top"
        case .bottom: return "bottom"
        case .left: return "left"
        case .right: return "right"
        default: return "other"
        }
    }
}

private extension CGPoint {
    var inspectorDescription: String { String(format: "(%.1f, %.1f)", x, y) }
}

private extension CGSize {
    var inspectorDescription: String { String(format: "%.1f × %.1f", width, height) }
}
