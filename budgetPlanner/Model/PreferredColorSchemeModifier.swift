import SwiftUI
struct PreferredColorSchemeModifier: ViewModifier {
    @AppStorage("isDarkModeActive") var isDarkModeActive: Bool = false

    func body(content: Content) -> some View {
        content
            .preferredColorScheme(isDarkModeActive ? .dark : .light)
    }
}
