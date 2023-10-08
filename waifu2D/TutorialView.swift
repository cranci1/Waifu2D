import SwiftUI

struct TutorialSlideView: View {
    var imageName: String
    var text: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 500)
                .cornerRadius(20)

            Text(text)
                .font(.system(size: 18))
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
        }
    }
}

struct TutorialView: View {
    @Binding var isPresented: Bool
    @State private var currentPage: Int = 0

    var body: some View {
        NavigationView {
            TabView(selection: $currentPage) {
                TutorialSlideView(imageName: "gallery", text: "Slide from Right to Left to open the gallery")
                    .tag(0)
                TutorialSlideView(imageName: "photo", text: "Slide from Left to Right to choose an image")
                    .tag(1)
                TutorialSlideView(imageName: "color", text: "Slide from the Bottom to the Top to change the background colour.")
                    .tag(2)
                TutorialSlideView(imageName: "settings", text: "Slide from the Top to the Bottom to open settings. Or just tripple tap on the screen.")
                    .tag(3)
            }
            
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .navigationBarTitle("Tutorial", displayMode: .inline)
            .navigationBarItems(trailing: Button("close") {
                isPresented = false
            })
        }
    }
}
