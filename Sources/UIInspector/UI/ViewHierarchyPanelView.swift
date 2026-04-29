import SwiftUI

struct ViewHierarchyPanelView: View {
    let root: ViewNode
    let onSelect: (ViewNode) -> Void

    @State private var expandedIDs: Set<UUID> = []
    @State private var selectedID: UUID?
    @State private var searchText = ""

    private var flatNodes: [ViewNode] {
        flatten(root)
    }

    private var filteredNodes: [ViewNode] {
        guard !searchText.isEmpty else { return flatNodes }
        return flatNodes.filter {
            $0.className.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredNodes, id: \.id) { node in
                HierarchyRow(
                    node: node,
                    isExpanded: expandedIDs.contains(node.id),
                    isSelected: selectedID == node.id,
                    onToggle: { toggle(node) },
                    onSelect: {
                        selectedID = node.id
                        onSelect(node)
                    }
                )
                .listRowInsets(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 8))
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "クラス名で検索")
            .navigationTitle("View Hierarchy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button("すべて展開") { expandAll(root) }
                        Button("すべて折りたたむ") { expandedIDs.removeAll() }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear { expandAll(root) }
    }

    private func flatten(_ node: ViewNode) -> [ViewNode] {
        guard searchText.isEmpty else {
            // 検索時はすべて展開して返す
            return flattenAll(node)
        }
        var result = [node]
        if expandedIDs.contains(node.id) {
            node.children.forEach { result += flatten($0) }
        }
        return result
    }

    private func flattenAll(_ node: ViewNode) -> [ViewNode] {
        var result = [node]
        node.children.forEach { result += flattenAll($0) }
        return result
    }

    private func expandAll(_ node: ViewNode) {
        expandedIDs.insert(node.id)
        node.children.forEach { expandAll($0) }
    }

    private func toggle(_ node: ViewNode) {
        if expandedIDs.contains(node.id) {
            expandedIDs.remove(node.id)
        } else {
            expandedIDs.insert(node.id)
        }
    }
}

private struct HierarchyRow: View {
    let node: ViewNode
    let isExpanded: Bool
    let isSelected: Bool
    let onToggle: () -> Void
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 0) {
                // インデント
                Color.clear.frame(width: CGFloat(node.depth) * 14)

                // 展開トグル
                if !node.isLeaf {
                    Button(action: onToggle) {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 18, height: 18)
                    }
                    .buttonStyle(.plain)
                } else {
                    Color.clear.frame(width: 18)
                }

                // クラス名 + フレーム
                VStack(alignment: .leading, spacing: 1) {
                    Text(node.className)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(isSelected ? .white : .primary)
                        .lineLimit(1)
                    Text(node.frameDescription)
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundStyle(isSelected ? Color.white.opacity(0.75) : .secondary)
                }

                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 8)
            .background(isSelected ? Color.blue : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }
}
