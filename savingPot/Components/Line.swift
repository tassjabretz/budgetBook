//
//  SwiftUIView.swift
//  savingPot
//
//  Created by Tassja Bretz on 03.10.25.
//

import SwiftUI

struct Line: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 1)
            .overlay(.black)
            
    }
}



