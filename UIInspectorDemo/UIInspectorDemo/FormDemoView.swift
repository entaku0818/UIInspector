import SwiftUI

struct FormDemoView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var bio = ""
    @State private var age = 25
    @State private var isPushEnabled = true
    @State private var isDarkMode = false
    @State private var selectedLanguage = "Swift"
    @State private var sliderValue = 0.5
    @State private var selectedColor = Color.blue

    private let languages = ["Swift", "Kotlin", "TypeScript", "Python", "Rust"]

    var body: some View {
        Form {
            Section("基本情報") {
                LabeledContent("名前") {
                    TextField("入力してください", text: $name)
                        .multilineTextAlignment(.trailing)
                }
                LabeledContent("メール") {
                    TextField("example@mail.com", text: $email)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }
                LabeledContent("年齢") {
                    Stepper("\(age)", value: $age, in: 1...120)
                }
            }

            Section("自己紹介") {
                TextEditor(text: $bio)
                    .frame(minHeight: 80)
            }

            Section("好きな言語") {
                Picker("言語", selection: $selectedLanguage) {
                    ForEach(languages, id: \.self) { Text($0) }
                }
                .pickerStyle(.menu)
            }

            Section("設定") {
                Toggle("プッシュ通知", isOn: $isPushEnabled)
                Toggle("ダークモード", isOn: $isDarkMode)
                ColorPicker("テーマカラー", selection: $selectedColor)
            }

            Section("音量") {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundStyle(.secondary)
                        Slider(value: $sliderValue)
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundStyle(.secondary)
                    }
                    Text(String(format: "%.0f%%", sliderValue * 100))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }

            Section {
                Button {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Text("保存")
                        .frame(maxWidth: .infinity)
                        .bold()
                }
                .buttonStyle(.borderedProminent)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Form")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack { FormDemoView() }
}
