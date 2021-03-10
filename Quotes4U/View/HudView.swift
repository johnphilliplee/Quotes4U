import SwiftUI

enum ImageType {
    case down, cross
}

struct HudView: View {
    let imageType: ImageType

    var body: some View {
        imageForType(imageType)
            .resizable()
            .offset(x: 0, y: imageType == .down ? 35 : 0)
            .clipShape(Circle())
            .aspectRatio(contentMode: .fit)
            .overlay(Circle().stroke(lineWidth: 3).foregroundColor(colorForType(imageType)))
//            .foregroundColor(colorForType(imageType))
//            .background(Color.clear)
    }

    private func colorForType(_ type: ImageType) -> Color {
        switch type {
        case .down:
            return Color.green
        case .cross:
            return Color.red
        }
    }

    private func imageForType(_ type: ImageType) -> Image {
        switch type {
        case .down:
            return Image(uiImage: UIImage(named: "kanye-smile")!)
//            return Image(systemName: "icloud.and.arrow.down")
        case .cross:
            return Image(uiImage: UIImage(named: "kanye-mad")!)
//            return Image(systemName: "xmark.icloud")
        }
    }
}

struct HudView_Previews: PreviewProvider {
    static var previews: some View {
        HudView(imageType: .cross)
    }
}
