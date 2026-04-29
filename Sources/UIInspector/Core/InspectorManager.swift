import UIKit
import SwiftUI

@MainActor
final class InspectorManager: InspectorContext {
    let plugins: [any InspectorPlugin]
    private(set) var inspectorWindow: InspectorWindow?
    private var activePlugin: (any InspectorPlugin)?
    private var highlightOverlays: [UIView] = []
    private var selectionOverlay: SelectionOverlayView?
    private var currentPanel: UIViewController?

    init(plugins: [any InspectorPlugin]) {
        self.plugins = plugins
    }

    func setup() {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }
        let window = InspectorWindow(windowScene: scene)
        window.manager = self
        window.setup()
        inspectorWindow = window
    }

    // MARK: - InspectorContext

    var appWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { !($0 is InspectorWindow) }
    }

    func startViewSelection(onSelect: @escaping @MainActor (UIView) -> Void) {
        guard let rootView = inspectorWindow?.rootViewController?.view else { return }
        stopViewSelection()
        dismissPanel(animated: false)

        let overlay = SelectionOverlayView(frame: rootView.bounds)
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.appWindow = appWindow
        overlay.onViewSelected = { [weak self] view in
            self?.stopViewSelection()
            onSelect(view)
        }
        rootView.addSubview(overlay)
        selectionOverlay = overlay
        inspectorWindow?.floatingButton?.alpha = 0.4
    }

    func stopViewSelection() {
        selectionOverlay?.removeFromSuperview()
        selectionOverlay = nil
        inspectorWindow?.floatingButton?.alpha = 1.0
    }

    @discardableResult
    func highlight(view: UIView, color: UIColor, label: String?) -> HighlightToken {
        guard let appWindow = appWindow,
              let rootView = inspectorWindow?.rootViewController?.view else {
            return HighlightToken(overlayView: UIView())
        }
        let frame = view.convert(view.bounds, to: appWindow)
        let overlay = HighlightView(frame: frame)
        overlay.borderColor = color
        overlay.labelText = label
        overlay.isUserInteractionEnabled = false
        rootView.addSubview(overlay)
        highlightOverlays.append(overlay)
        return HighlightToken(overlayView: overlay)
    }

    func removeHighlight(_ token: HighlightToken) {
        token.overlayView.removeFromSuperview()
        highlightOverlays.removeAll { $0 === token.overlayView }
    }

    func clearHighlights() {
        highlightOverlays.forEach { $0.removeFromSuperview() }
        highlightOverlays.removeAll()
    }

    func presentPanel(_ viewController: UIViewController, animated: Bool) {
        dismissPanel(animated: false)
        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        inspectorWindow?.rootViewController?.present(viewController, animated: animated)
        currentPanel = viewController
    }

    func dismissPanel(animated: Bool) {
        currentPanel?.dismiss(animated: animated)
        currentPanel = nil
    }

    // MARK: - Inspector control

    func showPluginMenu() {
        guard let rootVC = inspectorWindow?.rootViewController else { return }
        guard rootVC.presentedViewController == nil else { return }

        let menuView = PluginMenuView(plugins: plugins) { [weak self, weak rootVC] plugin in
            rootVC?.dismiss(animated: true) {
                self?.activatePlugin(plugin)
            }
        } onClose: { [weak rootVC] in
            rootVC?.dismiss(animated: true)
        }

        let hostingVC = UIHostingController(rootView: menuView)
        hostingVC.modalPresentationStyle = .pageSheet
        if let sheet = hostingVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        rootVC.present(hostingVC, animated: true)
    }

    func activatePlugin(_ plugin: any InspectorPlugin) {
        activePlugin?.deactivate()
        clearHighlights()
        stopViewSelection()
        dismissPanel(animated: false)
        activePlugin = plugin
        plugin.activate(context: self)
    }

    func deactivate() {
        activePlugin?.deactivate()
        activePlugin = nil
        clearHighlights()
        stopViewSelection()
        dismissPanel(animated: true)
    }
}
