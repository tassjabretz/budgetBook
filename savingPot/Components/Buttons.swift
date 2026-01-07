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
          .background(.green)
          .cornerRadius(20)
          .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
         
            
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



