//
//  SettingsView.swift
//  waifu2D
//
//  Created by Francesco on 16/09/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var isSettingsVisible = false
    
    @Binding var isHaptic2Enabled: Bool
    @Binding var isGestureEnabled: Bool
    @Binding var isButtonEnabled: Bool
    @Binding var isPasscodeEnabled: Bool
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
    let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            content
        }
        .navigationViewStyle(StackNavigationViewStyle())
        #else
        HStack {
            NavigationView {
                List {
                    settingsList
                }
                .navigationBarItems(leading: Button("Close") {
                    isSettingsVisible.toggle()
                })
                .navigationTitle("Settings")
            }
            .frame(width: 300)
            
            content
        }
        #endif
    }
    
    var content: some View {
        Form {
            Section(header: Text("General"), footer: Text("If you enable/disable 'Use Buttons' you need to restart the app to see them.")) {
                Toggle(isOn: $isHaptic2Enabled, label: {
                    Text("Vibration Feedback")
                })
                
                Toggle(isOn: $isButtonEnabled, label: {
                    Text("Use Buttons")
                })
                
                Toggle(isOn: $isGestureEnabled, label: {
                    Text("Use Gestures")
                })
            }
            
            Section(header: Text("Security"), footer: Text("If no Biometric Authentication is enabled on the device the passcode will be asked.")) {
                Toggle(isOn: $isPasscodeEnabled, label: {
                    Text("Biometric Authentication")
                })
            }
            
            
            Section(header: Text("Submition")) {
                HStack {
                    Text("Submit Waifu")
                }
                .font(.system(size: 15, weight: .regular))
                .onTapGesture {
                    if let url = URL(string: "https://cranci1.github.io/myWaifu2D/submit.html") {
                        UIApplication.shared.open(url)
                    }
                }
            }
            
            
            Section(header: Text("Support"), footer: Text("Every amount of money is appreciated.") ) {
                HStack {
                    Text("Ko-fi")
                }
                .font(.system(size: 15, weight: .regular))
                .onTapGesture {
                    if let url = URL(string: "https://ko-fi.com/cranci") {
                        UIApplication.shared.open(url)
                    }
                }
                
                HStack {
                    Text("PayPal")
                }
                .font(.system(size: 15, weight: .regular))
                .onTapGesture {
                    if let url = URL(string: "https://paypal.me/Cranci22") {
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
    }
    
    var settingsList: some View {
        Form {
            Section {
                NavigationLink(destination: EmptyView()) {
                    Text("Placeholder for Settings")
                }
            }
        }
        .navigationBarTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView (
            isHaptic2Enabled: .constant(false),
            isGestureEnabled: .constant(true),
            isButtonEnabled: .constant(true),
            isPasscodeEnabled: .constant(false)
        )
        .preferredColorScheme(.dark)
    }
}
