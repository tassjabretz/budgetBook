
import SwiftUI

struct Line: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(height: 1)
            .overlay(.adaptiveBlack)
            
    }
}



