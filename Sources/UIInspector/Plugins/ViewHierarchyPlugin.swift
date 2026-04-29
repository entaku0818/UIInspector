import UIKit
import SwiftUI

@MainActor
public final class ViewHierarchyPlugin: InspectorPlugin {
    public let id = "com.uiinspector.viewhierarchy"
    public let name = "View Hierarchy"
    public let iconName = "square.3.layers.3d"
    public let pluginDescription = "ビュー階層をツリー表示して選択・ハイライト"

    private weak var context: (any InspectorContext)?
    private var selectedToken: HighlightToken?

    public init() {}

    public func activate(context: any InspectorContext) {
        self.context = context
        guard let appWindow = context.appWindow else { return }

        let root = buildHierarchy(from: appWindow)
        let panelView = ViewHierarchyPanelView(root: root) { [weak self] node in
            self?.selectNode(node)
        }
        let hostingVC = UIHostingController(rootView: panelView)
        context.presentPanel(hostingVC, animated: true)
    }

    public func deactivate() {
        if let token = selectedToken { context?.removeHighlight(token) }
        selectedToken = nil
        context = nil
    }

    private func selectNode(_ node: ViewNode) {
        if let token = selectedToken { context?.removeHighlight(token) }
        selectedToken = context?.highlight(view: node.view, color: .systemBlue, label: node.shortClassName)
    }

    func buildHierarchy(from view: UIView, depth: Int = 0) -> ViewNode {
        let children = view.subviews.map { buildHierarchy(from: $0, depth: depth + 1) }
        return ViewNode(view: view, depth: depth, children: children)
    }
}

// MARK: - View Hierarchy Data Model

final class ViewNode: Identifiable {
    let id = UUID()
    let view: UIView
    let depth: Int
    let children: [ViewNode]

    var className: String { String(describing: type(of: view)) }

    var shortClassName: String {
        let full = className
        // UIKit prefix を除去して短く表示
        if full.hasPrefix("_") { return full }
        return full
    }

    var frameDescription: String {
        let f = view.frame
        return String(format: "(%.0f,%.0f) %.0f×%.0f", f.origin.x, f.origin.y, f.width, f.height)
    }

    var isLeaf: Bool { children.isEmpty }

    init(view: UIView, depth: Int, children: [ViewNode]) {
        self.view = view
        self.depth = depth
        self.children = children
    }
}
