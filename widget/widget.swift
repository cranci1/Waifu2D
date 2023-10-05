import SwiftUI
import WidgetKit

struct CustomWidgetView: View {
    let imageName: String

    var body: some View {
        ZStack {
            Color(hex: "202020") // Set the background color

            VStack {
                Spacer()

                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(10)

                Spacer()
            }
        }
    }
}

@main
struct CustomWidget: Widget {
    let kind: String = "myWaifu2D"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CustomWidgetView(imageName: entry.imageName)
        }
        .configurationDisplayName("myWaifu2D Widget")
        .description("widgets")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CustomWidgetEntry {
        CustomWidgetEntry(imageName: "bunny")
    }

    func getSnapshot(in context: Context, completion: @escaping (CustomWidgetEntry) -> ()) {
        let entry = CustomWidgetEntry(imageName: "bunny")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let imageName: String
        
        switch context.family {
        case .systemSmall:
            imageName = "sakuta"
        case .systemMedium:
            imageName = "medium"
        case .systemLarge:
            imageName = "bunny"
        case .systemExtraLarge:
            imageName = "medium"
        @unknown default:
            imageName = "bunny"
        }
        
        let entry = CustomWidgetEntry(imageName: imageName)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct CustomWidgetEntry: TimelineEntry {
    let date = Date()
    let imageName: String
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0

        scanner.scanHexInt64(&rgb)

        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
}
