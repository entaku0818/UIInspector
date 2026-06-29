import SwiftUI

struct CardListDemoView: View {
    @State private var searchText = ""
    @State private var selectedCategory: Category = .all

    private var filtered: [Item] {
        items.filter {
            (selectedCategory == .all || $0.category == selectedCategory) &&
            (searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Category picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Category.allCases, id: \.self) { cat in
                            CategoryChip(
                                title: cat.label,
                                isSelected: selectedCategory == cat
                            ) {
                                selectedCategory = cat
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Cards
                LazyVStack(spacing: 12) {
                    ForEach(filtered) { item in
                        ItemCard(item: item)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .searchable(text: $searchText, prompt: "検索")
        .navigationTitle("Card List")
        .navigationBarTitleDisplayMode(.inline)
    }

    private let items: [Item] = [
        Item(id: 1, title: "SwiftUI の基本", description: "View, State, Binding など基礎を学ぶ", category: .swift, icon: "swift", color: .orange),
        Item(id: 2, title: "UIKit の活用", description: "UIViewController ライフサイクルを理解する", category: .uikit, icon: "rectangle.3.group", color: .blue),
        Item(id: 3, title: "Combine 入門", description: "Publisher と Subscriber を使いこなす", category: .swift, icon: "dot.radiowaves.left.and.right", color: .green),
        Item(id: 4, title: "Core Data", description: "永続化の基本パターンを習得する", category: .data, icon: "cylinder", color: .purple),
        Item(id: 5, title: "Auto Layout", description: "制約ベースのレイアウトをマスター", category: .uikit, icon: "aspectratio", color: .blue),
        Item(id: 6, title: "async/await", description: "モダンな非同期処理を使う", category: .swift, icon: "bolt", color: .yellow),
        Item(id: 7, title: "URLSession", description: "REST API との通信を実装する", category: .data, icon: "network", color: .teal),
        Item(id: 8, title: "アニメーション", description: "SwiftUI アニメーションの全手法", category: .swift, icon: "sparkles", color: .pink)
    ]
}

// MARK: - Models

enum Category: String, CaseIterable {
    case all, swift, uikit, data
    var label: String {
        switch self {
        case .all: return "すべて"
        case .swift: return "Swift"
        case .uikit: return "UIKit"
        case .data: return "Data"
        }
    }
}

struct Item: Identifiable {
    let id: Int
    let title: String
    let description: String
    let category: Category
    let icon: String
    let color: Color
}

// MARK: - Components

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct ItemCard: View {
    let item: Item

    var body: some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 12)
                .fill(item.color.opacity(0.15))
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: item.icon)
                        .font(.title2)
                        .foregroundStyle(item.color)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack { CardListDemoView() }
}
