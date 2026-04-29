import SwiftUI

struct PluginMenuView: View {
    let plugins: [any InspectorPlugin]
    let onSelect: (any InspectorPlugin) -> Void
    let onClose: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(plugins, id: \.id) { plugin in
                        Button(action: { onSelect(plugin) }) {
                            PluginRow(plugin: plugin)
                        }
                        .foregroundStyle(.primary)
                    }
                } header: {
                    Text("検査モードを選択")
                        .font(.caption)
                        .textCase(nil)
                }
            }
            .navigationTitle("UIInspector")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("閉じる", action: onClose)
                }
            }
        }
    }
}

private struct PluginRow: View {
    let plugin: any InspectorPlugin

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: plugin.iconName)
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 44, height: 44)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 3) {
                Text(plugin.name)
                    .font(.headline)
                Text(plugin.pluginDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}
