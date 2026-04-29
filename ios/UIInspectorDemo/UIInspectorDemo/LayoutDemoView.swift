import SwiftUI

struct LayoutDemoView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                hstackSection
                vstackSection
                zstackSection
                gridSection
                alignmentSection
                nestedSection
            }
            .padding()
        }
        .navigationTitle("Layout")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hstackSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("HStack")
            HStack(spacing: 8) {
                colorBlock("赤", color: .red)
                colorBlock("緑", color: .green)
                colorBlock("青", color: .blue)
            }
        }
    }

    private var vstackSection: some View {
        VStack(alignment: .leading, spacing: 8) {
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
        }
    }

    private var zstackSection: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                Text("ZStack").font(.headline).foregroundStyle(.white)
            }
        }
    }

    private var gridSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Grid")
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3),
                spacing: 8
            ) {
                ForEach(0..<9, id: \.self) { i in
                    GridCell(index: i)
                }
            }
        }
    }

    private var alignmentSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("Spacer / Alignment")
            VStack(spacing: 8) {
                alignRow("左寄せ", alignment: .leading, color: .green)
                alignRow("中央", alignment: .center, color: .orange)
                alignRow("右寄せ", alignment: .trailing, color: .red)
            }
        }
    }

    private var nestedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("ネストしたビュー")
            NestedBoxView(depth: 4)
                .frame(height: 160)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title).font(.headline).foregroundStyle(.secondary)
    }

    private func colorBlock(_ label: String, color: Color) -> some View {
        color
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                Text(label)
                    .foregroundStyle(.white)
                    .font(.caption)
                    .bold()
            )
            .frame(maxWidth: .infinity)
    }

    private func alignRow(_ label: String, alignment: HorizontalAlignment, color: Color) -> some View {
        VStack(alignment: alignment) {
            Text(label)
        }
        .frame(maxWidth: .infinity, alignment: .init(horizontal: alignment, vertical: .center))
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Sub-views

private struct GridCell: View {
    let index: Int
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(hue: Double(index) / 9.0, saturation: 0.6, brightness: 0.85))
            .frame(height: 70)
            .overlay(
                Text("\(index + 1)").font(.headline).foregroundStyle(.white)
            )
    }
}

private struct NestedBoxView: View {
    let depth: Int
    private let colors: [Color] = [.blue, .green, .orange, .purple]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: CGFloat(depth) * 4)
                .strokeBorder(colors[depth % colors.count], lineWidth: 2)
                .padding(CGFloat(4 - depth) * 12)
            innerContent
        }
    }

    @ViewBuilder
    private var innerContent: some View {
        if depth > 1 {
            NestedBoxView(depth: depth - 1)
        } else {
            Text("depth 1").font(.caption).foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack { LayoutDemoView() }
}
