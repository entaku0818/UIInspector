import SwiftUI

struct LayoutDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                sectionHeader("HStack")
                HStack(spacing: 8) {
                    ForEach(["赤", "緑", "青"], id: \.self) { label in
                        colorBlock(label, color: color(for: label))
                    }
                }

                sectionHeader("VStack")
                VStack(spacing: 8) {
                    ForEach(["ラベル A", "ラベル B", "ラベル C"], id: \.self) { label in
                        Text(label)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }

                sectionHeader("ZStack (重なり)")
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.purple.opacity(0.2))
                        .frame(height: 120)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.purple.opacity(0.3))
                        .frame(width: 200, height: 80)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.purple.opacity(0.5))
                        .frame(width: 120, height: 50)
                    Text("ZStack")
                        .font(.headline)
                        .foregroundStyle(.white)
                }

                sectionHeader("Grid")
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(0..<9, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hue: Double(i) / 9.0, saturation: 0.6, brightness: 0.85))
                            .frame(height: 70)
                            .overlay(Text("\(i + 1)").font(.headline).foregroundStyle(.white))
                    }
                }

                sectionHeader("Spacer / Alignment")
                VStack(spacing: 8) {
                    HStack {
                        Text("左寄せ")
                        Spacer()
                    }
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    HStack {
                        Spacer()
                        Text("中央")
                        Spacer()
                    }
                    .padding()
                    .background(Color.orange.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    HStack {
                        Spacer()
                        Text("右寄せ")
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                sectionHeader("ネストしたビュー")
                nestedView(depth: 4)
            }
            .padding()
        }
        .navigationTitle("Layout")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.secondary)
    }

    private func colorBlock(_ label: String, color: Color) -> some View {
        color
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(Text(label).foregroundStyle(.white).font(.caption).bold())
            .frame(maxWidth: .infinity)
    }

    private func color(for label: String) -> Color {
        switch label {
        case "赤": return .red
        case "緑": return .green
        default: return .blue
        }
    }

    private func nestedView(depth: Int) -> some View {
        let colors: [Color] = [.blue, .green, .orange, .purple]
        return AnyView(
            ZStack {
                RoundedRectangle(cornerRadius: CGFloat(depth) * 4)
                    .strokeBorder(colors[depth % colors.count], lineWidth: 2)
                    .padding(CGFloat(4 - depth) * 12)
                if depth > 1 {
                    nestedView(depth: depth - 1)
                } else {
                    Text("depth 1")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(height: 160)
        )
    }
}

#Preview {
    NavigationStack { LayoutDemoView() }
}
