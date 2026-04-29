import SwiftUI

struct OverlayDemoView: View {
    @State private var showSheet = false
    @State private var showAlert = false
    @State private var showBanner = false
    @State private var badgeCount = 3
    @State private var progress = 0.4

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Badge
                GroupBox("バッジ") {
                    HStack(spacing: 24) {
                        Button {
                            if badgeCount > 0 { badgeCount -= 1 }
                        } label: {
                            Image(systemName: "minus.circle")
                                .font(.title2)
                        }

                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(.blue)
                            if badgeCount > 0 {
                                Text("\(badgeCount)")
                                    .font(.caption2.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .frame(width: 60, height: 60)

                        Button {
                            badgeCount += 1
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                // Progress
                GroupBox("プログレス") {
                    VStack(spacing: 12) {
                        ProgressView(value: progress)
                            .tint(.blue)
                        HStack {
                            Button("- 10%") { progress = max(0, progress - 0.1) }
                                .buttonStyle(.bordered)
                            Spacer()
                            Text(String(format: "%.0f%%", progress * 100))
                                .font(.headline.monospacedDigit())
                            Spacer()
                            Button("+ 10%") { progress = min(1, progress + 0.1) }
                                .buttonStyle(.bordered)
                        }
                        ProgressView()
                            .tint(.purple)
                    }
                    .padding(.vertical, 4)
                }

                // Toast / Banner
                GroupBox("バナー") {
                    VStack(spacing: 8) {
                        Button("バナーを表示") {
                            showBanner = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                showBanner = false
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                }

                // Sheet
                GroupBox("シート / アラート") {
                    HStack(spacing: 12) {
                        Button("Sheet") { showSheet = true }
                            .buttonStyle(.bordered)
                            .frame(maxWidth: .infinity)
                        Button("Alert") { showAlert = true }
                            .buttonStyle(.bordered)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.vertical, 4)
                }

                // Tooltip-like overlay
                GroupBox("ツールチップ風") {
                    HStack(spacing: 12) {
                        ForEach(["Swift", "UIKit", "SwiftUI"], id: \.self) { tag in
                            Text(tag)
                                .font(.caption.bold())
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundStyle(.accentColor)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.accentColor.opacity(0.4), lineWidth: 1)
                                )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Overlay")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .top) {
            if showBanner {
                BannerView()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.spring(duration: 0.4), value: showBanner)
                    .padding(.top, 8)
            }
        }
        .sheet(isPresented: $showSheet) {
            VStack(spacing: 16) {
                Text("シート").font(.title2.bold())
                Text("UIInspector でこのシートも検査できます。")
                    .foregroundStyle(.secondary)
                Button("閉じる") { showSheet = false }
                    .buttonStyle(.borderedProminent)
            }
            .padding()
            .presentationDetents([.medium])
        }
        .alert("確認", isPresented: $showAlert) {
            Button("OK") {}
            Button("キャンセル", role: .cancel) {}
        } message: {
            Text("これはアラートのデモです。")
        }
    }
}

struct BannerView: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.title3)
            Text("操作が完了しました")
                .font(.subheadline.bold())
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 6, y: 2)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack { OverlayDemoView() }
}
