import SwiftUI

struct Trapezium: Shape {
    let offsetPercentage: CGFloat

    init(offsetPercentage: CGFloat = 0.6) {
        self.offsetPercentage = offsetPercentage
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: .zero)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY * offsetPercentage))
        path.closeSubpath()

        return path
    }
}

struct Trapezium_Previews: PreviewProvider {
    static var previews: some View {
        Trapezium()
            .fill()
    }
}
