
import SwiftUI

struct roundImage: View {
    
    
    let imageName: String
    
  
    var body: some View {

 
     
        Circle()
            .fill(Color.adaptiveGray)
            .frame(width: 40, height: 40)
            .scaledToFit()
            .foregroundStyle(.adaptiveBlack)
            .overlay(
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.adaptiveBlack)
            )

    }
}

struct ImageAppTour: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let imageName: String
    
    var body: some View {
        Circle()
            .fill(Color.adaptiveGrayAppTour.opacity(colorScheme == .light ? 0.09 :1))
            .padding(40)
            .frame(width: 420, height: 420)
            .overlay(
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                    .foregroundStyle(.adaptiveBlack)
            )
            .shadow(color: .black.opacity(0.30), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    ImageAppTour(imageName: "overview")
}





