import Foundation
import SwiftUI

struct TextHighlighter: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.themeBackground, radius: 0.4)
            .shadow(color: Color.themeBackground, radius: 0.4)
            .shadow(color: Color.themeBackground, radius: 0.4)
            .shadow(color: Color.themeBackground, radius: 0.4)
            .shadow(color: Color.themeBackground, radius: 0.4)
    }
}

extension View {
    func highlighted() -> some View {
        modifier(TextHighlighter())
    }
}
