import SwiftUI

struct ProfileDemoView: View {
    private let stats: [ProfileStat] = [
        ProfileStat(label: "投稿", value: "142"),
        ProfileStat(label: "フォロワー", value: "1.2K"),
        ProfileStat(label: "フォロー中", value: "380")
    ]
    private let posts = (1...8).map { i in
        Post(id: i, text: "投稿 #\(i): UIInspector のデモ用サンプルテキストです。", date: "Apr \(29 - i)")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                infoView
                Divider()
                statsView
                Divider()
                postsView
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [.blue, .purple],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 160)

            Circle()
                .fill(Color.white)
                .frame(width: 84, height: 84)
                .overlay(Text("👤").font(.system(size: 40)))
                .padding([.leading, .bottom], 16)
                .shadow(radius: 4)
        }
    }

    private var infoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Takumi Endo").font(.title2).bold()
                    Text("@entaku0818").font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Button("フォロー") {}
                    .buttonStyle(.borderedProminent)
            }
            Text("iOS Developer. Swift / UIKit / SwiftUI.\nUIInspector 作ってます。")
            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse").foregroundStyle(.secondary)
                Text("Tokyo, Japan").font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    private var statsView: some View {
        HStack {
            ForEach(stats) { stat in
                Spacer()
                VStack(spacing: 2) {
                    Text(stat.value).font(.headline).bold()
                    Text(stat.label).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                if stat.id != stats.last?.id {
                    Divider().frame(height: 30)
                }
            }
        }
        .padding(.vertical, 12)
    }

    private var postsView: some View {
        LazyVStack(spacing: 1) {
            ForEach(posts) { post in
                PostRow(post: post)
                Divider()
            }
        }
    }
}

// MARK: - Models

struct ProfileStat: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

struct Post: Identifiable {
    let id: Int
    let text: String
    let date: String
}

// MARK: - Components

struct PostRow: View {
    let post: Post

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(Text("👤"))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Takumi Endo").font(.subheadline).bold()
                    Spacer()
                    Text(post.date).font(.caption).foregroundStyle(.secondary)
                }
                Text(post.text).font(.body)
                HStack(spacing: 24) {
                    Label("12", systemImage: "heart")
                    Label("3", systemImage: "bubble.right")
                    Label("2", systemImage: "arrow.2.squarepath")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

#Preview {
    NavigationStack { ProfileDemoView() }
}
