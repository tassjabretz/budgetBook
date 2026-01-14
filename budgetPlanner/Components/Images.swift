//
//  SwiftUIView.swift
//  savingPot
//
//  Created by Tassja Bretz on 03.10.25.
//

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
    let imageName: String
    
    var body: some View {
        Circle()
            .fill(Color.adaptiveGray.opacity(0.2))
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





