import SwiftUI

struct SettingsView: View {
    @State private var isSettingsVisible = false
    @State private var isTutorialVisible = false
    
    @Binding var isHaptic2Enabled: Bool
    @Binding var isGestureEnabled: Bool
    @Binding var isButtonEnabled: Bool
    @Binding var isSoundEnabled: Bool
    
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: EmptyView(), isActive: $isSettingsVisible) {
                EmptyView()
            }
            .hidden()
            
            Form {
                Section(header: Text("General"), footer: Text("The haptic feedback is the vibration when pressing a button.  If you enable/disable 'Use Buttons' you need to restart the app to see them.  Sound Effects plays when you tap the center of the screen.")) {
                    
                    Toggle(isOn: $isHaptic2Enabled, label: {
                        Text("Haptic feedback for all buttons")
                    })
                    
                    Toggle(isOn: $isSoundEnabled, label: {
                        Text("Sound Effects")
                    })
                
                    Toggle(isOn: $isButtonEnabled, label: {
                        Text("Use Buttons")
                    })
                    
                    Toggle(isOn: $isGestureEnabled, label: {
                        Text("Use Gestures")
                    })
                    
                }
                
                
                Section(header: Text("Tutorial"), footer: Text("If you want to learn how getures works.")) {
                    Button("Show Tutorial") {
                        isTutorialVisible.toggle()
                    }
                    .sheet(isPresented: $isTutorialVisible) {
                        TutorialView(isPresented: $isTutorialVisible)
                    }
                }
                
                Section {
                    
                    HStack {
                        Text("Submition form")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 16, weight: .semibold))
                    .onTapGesture {
                        if let url = URL(string: "https://www.cranci.xyz/myWaifu2D/submit.html") {
                            UIApplication.shared.open(url)
                        }
                    }
                    
                    HStack {
                        Text("Submit waifu")
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
            
            isHaptic2Enabled: .constant(false),
            isGestureEnabled: .constant(true),
            isButtonEnabled: .constant(true),
            isSoundEnabled: .constant(false)
        )
            .preferredColorScheme(.dark)
    }
}
