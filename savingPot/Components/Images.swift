//
//  SwiftUIView.swift
//  savingPot
//
//  Created by Tassja Bretz on 03.10.25.
//

import SwiftUI

struct roundImage: ViewModifier {
    
  
    func body(content: Content) -> some View {
       content
            .scaledToFit()
            .frame(width: 25, height: 25)
            .foregroundStyle(.adaptiveBlack)
    }
}





