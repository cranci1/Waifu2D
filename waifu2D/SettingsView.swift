import SwiftUI

struct SettingsView: View {
    @State private var isSettingsVisible = false
    @State private var isTutorialVisible = false
    
    @Binding var isHapticEnabled: Bool
    @Binding var isHaptic2Enabled: Bool
    @Binding var isAnimationEnabled: Bool
    @Binding var isGestureEnabled: Bool
    @Binding var isButtonEnabled: Bool
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: EmptyView(), isActive: $isSettingsVisible) {
                EmptyView()
            }
            .hidden()
            
            Form {
                Section(header: Text("General"), footer: Text("The haptic feedback is the vibration when switching variant/text. If you enable/disable 'Use Buttons' you need to restart the app to see them.")) {
                    
                    Toggle(isOn: $isHapticEnabled, label: {
                        Text("Haptic feedback for Variant")
                    })
                    
                    Toggle(isOn: $isHaptic2Enabled, label: {
                        Text("Haptic feedback for Text")
                    })
                    
                    Toggle(isOn: $isAnimationEnabled, label: {
                        Text("Animation when changing Variant")
                    })
                
                    Toggle(isOn: $isButtonEnabled, label: {
                        Text("Use Buttons")
                    })
                    
                    Toggle(isOn: $isGestureEnabled, label: {
                        Text("Use Gestures")
                    })
                    
                }
                
                
                Section(header: Text("Tutorial"), footer: Text("To lazy to make it like onBoarding Sorry.")) {
                    Button("Show Tutorial") {
                        isTutorialVisible.toggle()
                    }
                    .sheet(isPresented: $isTutorialVisible) {
                        TutorialView(isPresented: $isTutorialVisible)
                    }
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
                        Text("📧 Contact me via Email ")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .semibold))
                    .onTapGesture {
                        if let url = URL(string: "mailto:cranci@null.net") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                
                Section(header: Text("App Info")) {
                        HStack {
                        Text("Version: \(appVersion)")
                        }
                        HStack {
                        Text("Build: \(appBuild)")
                        }
                    
                    HStack {
                        Text("Github repo")
                    }
                    .font(.system(size: 16))
                    .onTapGesture {
                        if let url = URL(string: "https://github.com/cranci1/waifu2D/") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                }
                
            }
            .navigationBarBackButtonHidden(true)
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
            isHaptic2Enabled: .constant(false),
            isAnimationEnabled: .constant(false),
            isGestureEnabled: .constant(true),
            isButtonEnabled: .constant(true)
        )
            .preferredColorScheme(.dark)
    }
}
