import SwiftUI

struct SettingsView: View {
    @State private var isSettingsVisible = false
    
    @Binding var isHapticEnabled: Bool
    @Binding var isHaptic2Enabled: Bool
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: EmptyView(), isActive: $isSettingsVisible) {
                EmptyView()
            }
            .hidden()
            
            Form {
                Section(header: Text("General"), footer: Text("The haptic feedback is the vibration when switching variant/text")) {
                    Toggle(isOn: $isHapticEnabled, label: {
                        Text("Haptic feedback for variant")
                    })
                    
                    Toggle(isOn: $isHaptic2Enabled, label: {
                        Text("Haptic feedback for text")
                    })
                    
                }
                
                
                Section {
                    HStack {
                        Text("☕ Support me on Ko-fi")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .semibold))
                    .onTapGesture {
                        if let url = URL(string: "https://ko-fi.com/cranci") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    HStack {
                        Text("📧 Contact via Email ")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .semibold))
                    .onTapGesture {
                        if let url = URL(string: "mailto:cranci@null.net") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                
                Section(header: Text("About App")) {
                        HStack {
                        Text("Version: \(appVersion)")
                        }
                        HStack {
                        Text("Build: \(appBuild)")
                        }
                    
                    HStack {
                        Text("Github repo")
                    }
                    .onTapGesture {
                        if let url = URL(string: "https://github.com/cranci1/waifu2D/") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                }
            .navigationTitle("Settings")
            
            Button("Toggle Settings") {
                isSettingsVisible.toggle()
            }
        }
    }
  }

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView (
            isHapticEnabled: .constant(false),
            isHaptic2Enabled: .constant(false)
        )
            .preferredColorScheme(.dark)
    }
  }
}
