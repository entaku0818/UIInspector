import UIKit
import SwiftUI

@MainActor
public final class MeasurePlugin: InspectorPlugin {
    public let id = "com.uiinspector.measure"
    public let name = "Measure"
    public let iconName = "ruler"
    public let pluginDescription = "2つのビュー間の距離を計測"

    private weak var context: (any InspectorContext)?
    private var viewA: UIView?
    private var tokenA: HighlightToken?
    private var tokenB: HighlightToken?

    public init() {}

    public func activate(context: any InspectorContext) {
        self.context = context
        selectViewA()
    }

    public func deactivate() {
        context?.stopViewSelection()
        context?.clearHighlights()
        viewA = nil
        tokenA = nil
        tokenB = nil
        context = nil
    }

    private func selectViewA() {
        context?.startViewSelection { [weak self] view in
            guard let self else { return }
            self.viewA = view
            self.tokenA = self.context?.highlight(view: view, color: .systemOrange, label: "A")
            self.selectViewB()
        }
    }

    private func selectViewB() {
        context?.startViewSelection { [weak self] view in
            guard let self, let viewA = self.viewA else { return }
            self.tokenB = self.context?.highlight(view: view, color: .systemPurple, label: "B")
            self.showResult(viewA: viewA, viewB: view)
        }
    }

    private func showResult(viewA: UIView, viewB: UIView) {
        guard let appWindow = context?.appWindow else { return }
        let frameA = viewA.convert(viewA.bounds, to: appWindow)
        let frameB = viewB.convert(viewB.bounds, to: appWindow)

        let measurement = ViewMeasurement(
            frameA: frameA,
            classA: String(describing: type(of: viewA)),
            frameB: frameB,
            classB: String(describing: type(of: viewB))
        )

        let panelView = MeasurePanelView(measurement: measurement) { [weak self] in
            if let ta = self?.tokenA { self?.context?.removeHighlight(ta) }
            if let tb = self?.tokenB { self?.context?.removeHighlight(tb) }
            self?.viewA = nil
            self?.tokenA = nil
            self?.tokenB = nil
            self?.selectViewA()
        }
        let hostingVC = UIHostingController(rootView: panelView)
        context?.presentPanel(hostingVC, animated: true)
    }
}

// MARK: - Measurement Model

struct ViewMeasurement {
    let frameA: CGRect
    let classA: String
    let frameB: CGRect
    let classB: String

    var horizontalGap: CGFloat? {
        if frameA.maxX <= frameB.minX { return frameB.minX - frameA.maxX }
        if frameB.maxX <= frameA.minX { return frameA.minX - frameB.maxX }
        return nil
    }

    var verticalGap: CGFloat? {
        if frameA.maxY <= frameB.minY { return frameB.minY - frameA.maxY }
        if frameB.maxY <= frameA.minY { return frameA.minY - frameB.maxY }
        return nil
    }

    var centerDistance: CGFloat {
        let dx = frameB.midX - frameA.midX
        let dy = frameB.midY - frameA.midY
        return (dx*dx + dy*dy).squareRoot()
    }

    var isOverlapping: Bool { frameA.intersects(frameB) }
}
