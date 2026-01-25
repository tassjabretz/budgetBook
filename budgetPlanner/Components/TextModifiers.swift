

import Foundation
import SwiftUI

struct TextFieldModifierBig: ViewModifier {
    
    var isError: Bool
    @Environment(\.colorScheme) var colorScheme
    
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .textFieldStyle(.plain)
            .foregroundColor(.adaptiveBlack)
            .frame(height: 100)
            .font(.body)
            .tint(.adaptiveBlack)
            .background(Color.adaptiveWhiteCard)
            .cornerRadius(12)
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.08),
                radius: colorScheme == .dark ? 8 : 4,
                x: 0,
                y: colorScheme == .dark ? 4 : 2
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isError ? Color.red : Color.adaptiveBlack.opacity(colorScheme == .dark ? 0.15 : 0.05),
                        lineWidth: isError ? 2 : 1
                    )
            )
    }
}




struct TextFieldModifier: ViewModifier {
    var isError: Bool
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .textFieldStyle(.plain)
            .foregroundColor(.adaptiveBlack)
            .frame(height: 55)
            .font(.body)
            .tint(.adaptiveBlack)
            .background(Color.adaptiveWhiteCard)
            .cornerRadius(12)
            .shadow(
                color: Color.black.opacity(colorScheme == .dark ? 0.4 : 0.08),
                radius: colorScheme == .dark ? 8 : 4,
                x: 0,
                y: colorScheme == .dark ? 4 : 2
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isError ? Color.red : Color.adaptiveBlack.opacity(colorScheme == .dark ? 0.15 : 0.05),
                        lineWidth: isError ? 2 : 1
                    )
            )
    }
    
}

let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    return formatter
}()

