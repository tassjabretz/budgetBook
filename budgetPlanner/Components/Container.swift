//
//  Container.swift
//  budgetPlanner
//
//  Created by Tassja Bretz on 14.01.26.
//

import SwiftUI

struct containerBorder: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(Color.adaptiveWhiteCard)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.adaptiveBlack.opacity(0.3), lineWidth: 1)
            )
            .padding(.bottom, 10)
        
            
    }
}

