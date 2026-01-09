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

#Preview {
    roundImage(imageName: "house")
}





