import SwiftUI

struct ImageInfo {
    var name: String
    var author: String
    var imageName: String
}

struct GalleryItemView: View {
    @Environment(\.colorScheme) var colorScheme

    var image: ImageInfo
    @State private var isExpanded = false

    var body: some View {
            VStack(alignment: .leading) {
                // Check if the image can be loaded
                if let uiImage = UIImage(named: image.imageName) {
                    Image(uiImage: uiImage) // Use Image(uiImage:) initializer to load UIImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: isExpanded ? UIScreen.main.bounds.height / 2 : 200)
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                isExpanded.toggle()
                            }
                        }
                } else {
                    // Display a placeholder or an error message
                    Text("Image not found: \(image.imageName)")
                        .foregroundColor(.red)
                }

                Rectangle()
                    .fill(Color.primaryBackground)
                    .frame(height: isExpanded ? 50 : 30)
                    .overlay(
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(image.name)")
                                Text("\(image.author)")
                            }
                            .foregroundColor(Color.secondaryText)

                            Spacer()

                            Button(action: {
                                downloadAndSaveImage(imageName: image.imageName)
                            }) {
                                Image(systemName: "arrow.down.circle")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                    )
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.primaryBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(colorScheme == .dark ? Color.black : Color.gray, lineWidth: 2)
            )
            .fullScreenCover(isPresented: $isExpanded) {
                ExpandedGalleryItemView(image: image, isExpanded: $isExpanded)
            }
        }
}

struct GalleryView: View {
    let images: [ImageInfo]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                ForEach(images, id: \.imageName) { image in
                    GalleryItemView(image: image)
                }
            }
            .padding()
        }
    }
}

struct ExpandedGalleryItemView: View {
    var image: ImageInfo
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Image(image.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: .infinity)
                .cornerRadius(20)

            Rectangle()
                .fill(Color.primaryBackground)
                .frame(height: 50)
                .overlay(
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(image.name)")
                            Text("\(image.author)")
                        }
                        .foregroundColor(Color.secondaryText)

                        Spacer()
                    }
                    .padding()
                )
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.primaryBackground))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.primaryBackground, lineWidth: 2)
                .background(
                    Color.black.opacity(0.1)
                        .onTapGesture {
                            withAnimation {
                                isExpanded = false
                            }
                        }
                )
        )
    }
}

extension Color {
    static let primaryBackground: Color = Color(UIColor.systemBackground)
    static let secondaryText: Color = Color(UIColor.secondaryLabel)
}

func downloadAndSaveImage(imageName: String) {
    guard let image = UIImage(named: imageName) else {
        print("Error loading UIImage.")
        return
    }

    guard let data = image.pngData() else {
        print("Error getting PNG representation.")
        return
    }

    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    print("Image downloaded and saved to the Photos app successfully!")
}

struct ContentView: View {
    let galleryImages: [ImageInfo] = [
        ImageInfo(name: "Luna Shirakawa", author: "@kimizero_anime", imageName: "luna"),
        ImageInfo(name: "Mai Sakurajima half bunny", author: "@aobuta_anime", imageName: "mai-bunny-half"),
        ImageInfo(name: "Mai Sakurajima bunny", author: "@aobuta_anime", imageName: "mai-bunny"),
        ImageInfo(name: "Sakuta Azusagawa", author: "@aobuta_anime", imageName: "sakuta"),
        ImageInfo(name: "Nagisa Shiota", author: "@ansatsu_anime", imageName: "nagisa"),
        ImageInfo(name: "Kazuto Kirigaya", author: "@sao_anime", imageName: "kirito"),
        ImageInfo(name: "Asuna Yuuki", author: "@sao_anime", imageName: "asuna"),
        ImageInfo(name: "Aqua", author: "@konosubaanime", imageName: "aqua"),
    ]

    var body: some View {
        GalleryView(images: galleryImages)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
