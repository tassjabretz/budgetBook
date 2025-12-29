//
//  SwiftUIView.swift
//  savingPot
//
//  Created by Tassja Bretz on 03.10.25.
//

import SwiftUI


struct ButtonNormal: ViewModifier {

    var buttonTitel: String
    func body(content: Content) -> some View {
        content

        .frame(maxWidth: .infinity)
          .padding()
          .foregroundStyle(.adaptiveBlack)
          .background(.blueback)
          .cornerRadius(10)
         
            
    }
}

struct ButtonRed: ViewModifier {
  
    
    var buttonTitel: String
    func body(content: Content) -> some View {
        content

        .frame(maxWidth: .infinity)
          .padding()
          .foregroundColor(.black)
          .background(.red)
          .cornerRadius(10)
        
            
    }
}



