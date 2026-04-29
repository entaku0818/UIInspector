import SwiftUI

struct AttributesPanelView: View {
    let attributes: ViewAttributes
    let onSelectAnother: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section("Identity") {
                    AttributeCell(key: "class", value: attributes.className)
                    if let id = attributes.accessibilityIdentifier {
                        AttributeCell(key: "accessibilityIdentifier", value: id)
                    }
                    if let label = attributes.accessibilityLabel {
                        AttributeCell(key: "accessibilityLabel", value: label)
                    }
                    if attributes.tag != 0 {
                        AttributeCell(key: "tag", value: "\(attributes.tag)")
                    }
                }

                Section("Layout") {
                    AttributeCell(key: "frame", value: rectDescription(attributes.frame))
                    AttributeCell(key: "bounds", value: rectDescription(attributes.bounds))
                    AttributeCell(key: "clipsToBounds", value: "\(attributes.clipsToBounds)")
                    if attributes.cornerRadius > 0 {
                        AttributeCell(key: "cornerRadius", value: String(format: "%.1f", attributes.cornerRadius))
                    }
                }

                Section("Appearance") {
                    colorRow(key: "backgroundColor", color: attributes.backgroundColor)
                    AttributeCell(key: "alpha", value: String(format: "%.2f", attributes.alpha))
                    AttributeCell(key: "isHidden", value: "\(attributes.isHidden)")
                    AttributeCell(key: "isUserInteractionEnabled", value: "\(attributes.isUserInteractionEnabled)")
                }

                if !attributes.typeSpecific.isEmpty {
                    Section("Type Specific") {
                        ForEach(attributes.typeSpecific) { row in
                            AttributeCell(key: row.key, value: row.value)
                        }
                    }
                }
            }
            .navigationTitle(attributes.className)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("別のビューを選択") {
                        onSelectAnother()
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func colorRow(key: String, color: UIColor?) -> some View {
        HStack {
            Text(key)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
            Spacer()
            if let color {
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(uiColor: color))
                        .frame(width: 18, height: 18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.primary.opacity(0.15), lineWidth: 1)
                        )
                    Text(color.inspectorHexPublic)
                        .font(.system(.caption, design: .monospaced))
                }
            } else {
                Text("nil")
                    .font(.system(.caption, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func rectDescription(_ rect: CGRect) -> String {
        String(format: "(%.1f, %.1f) %.1f×%.1f", rect.origin.x, rect.origin.y, rect.width, rect.height)
    }
}

// MARK: - Shared Component

struct AttributeCell: View {
    let key: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(key)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(minWidth: 80, alignment: .leading)
            Spacer(minLength: 8)
            Text(value)
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
        }
    }
}
