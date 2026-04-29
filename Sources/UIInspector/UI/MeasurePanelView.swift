import SwiftUI

struct MeasurePanelView: View {
    let measurement: ViewMeasurement
    let onMeasureAgain: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    viewInfo(label: "A", className: measurement.classA, frame: measurement.frameA, color: .orange)
                    viewInfo(label: "B", className: measurement.classB, frame: measurement.frameB, color: .purple)
                } header: {
                    Text("対象ビュー")
                }

                Section("距離") {
                    if measurement.isOverlapping {
                        Label("重なっています", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.orange)
                            .font(.callout)
                    } else {
                        if let h = measurement.horizontalGap {
                            MeasureRow(icon: "arrow.left.and.right", label: "水平方向の隙間", value: h)
                        }
                        if let v = measurement.verticalGap {
                            MeasureRow(icon: "arrow.up.and.down", label: "垂直方向の隙間", value: v)
                        }
                    }
                    MeasureRow(icon: "arrow.up.left.and.arrow.down.right", label: "中心点間の距離", value: measurement.centerDistance)
                }
            }
            .navigationTitle("Measure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("もう一度計測", action: onMeasureAgain)
                }
            }
        }
    }

    @ViewBuilder
    private func viewInfo(label: String, className: String, frame: CGRect, color: Color) -> some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(color)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(className)
                    .font(.system(.caption, design: .monospaced))
                Text(String(format: "(%.1f, %.1f) %.1f×%.1f",
                            frame.origin.x, frame.origin.y, frame.width, frame.height))
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct MeasureRow: View {
    let icon: String
    let label: String
    let value: CGFloat

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.secondary)
                .frame(width: 20)
            Text(label)
                .font(.callout)
            Spacer()
            Text(String(format: "%.1f pt", value))
                .font(.system(.callout, design: .monospaced, weight: .semibold))
                .foregroundStyle(.blue)
        }
    }
}
