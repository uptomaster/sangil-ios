import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct MountainArtwork: View {
    let mountain: Mountain
    private var hasAsset: Bool {
        #if canImport(UIKit)
        UIImage(named: mountain.imageName) != nil
        #elseif canImport(AppKit)
        NSImage(named: mountain.imageName) != nil
        #else
        false
        #endif
    }
    var body: some View {
        GeometryReader { proxy in
            Group {
                if hasAsset {
                    Image(mountain.imageName).resizable().scaledToFill()
                } else if let url = mountain.imageURL {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image { image.resizable().scaledToFill() }
                        else { fallback }
                    }
                } else { fallback }
            }
            .frame(width: proxy.size.width, height: proxy.size.height).clipped()
        }
        .accessibilityLabel("\(mountain.name) 풍경")
    }
    private var fallback: some View {
        ZStack {
            LinearGradient(colors: [AppColors.surfaceSecondary, AppColors.background], startPoint: .topTrailing, endPoint: .bottomLeading)
            Canvas { context, size in
                for layer in 0..<3 {
                    var path = Path()
                    let offset = CGFloat(layer) * size.height * 0.16
                    path.move(to: CGPoint(x: 0, y: size.height))
                    path.addLine(to: CGPoint(x: 0, y: size.height * 0.7 + offset))
                    path.addLine(to: CGPoint(x: size.width * 0.32, y: size.height * 0.2 + offset))
                    path.addLine(to: CGPoint(x: size.width * 0.49, y: size.height * 0.48 + offset))
                    path.addLine(to: CGPoint(x: size.width * 0.72, y: size.height * 0.12 + offset))
                    path.addLine(to: CGPoint(x: size.width, y: size.height * 0.6 + offset))
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                    path.closeSubpath()
                    context.fill(path, with: .color(AppColors.accentCyan.opacity(0.07 + Double(layer) * 0.035)))
                }
            }
            VStack { HStack { Spacer(); Image(systemName: "sun.haze").font(.largeTitle).foregroundStyle(AppColors.accentYellow.opacity(0.6)) }; Spacer() }.padding(30)
        }
    }
}
