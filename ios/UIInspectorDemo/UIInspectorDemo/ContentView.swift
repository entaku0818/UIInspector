import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("デモ画面") {
                    NavigationLink("Profile", destination: ProfileDemoView())
                    NavigationLink("Form", destination: FormDemoView())
                    NavigationLink("Card List", destination: CardListDemoView())
                    NavigationLink("Layout", destination: LayoutDemoView())
                    NavigationLink("Overlay", destination: OverlayDemoView())
                }
                Section {
                    Text("シェイク または 🔍 ボタンで UIInspector を起動")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("UIInspector Demo")
        }
    }
}

#Preview {
    ContentView()
}
