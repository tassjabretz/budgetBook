//
//  TextModifiers.swift
//  savingPot
//
//  Created by Tassja Bretz on 17.10.25.
//

import Foundation
import SwiftUI

struct TextFieldModifierBig: ViewModifier {
 
    var isError: Bool
    
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
            .textFieldStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 5)
            .cornerRadius(2)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(isError ? Color.red : Color.clear, lineWidth: isError ? 2 : 0)
            )
            .font(.caption)
            .foregroundColor(.adaptiveBlack)
            .background(.adaptiveWhiteCard)
      
            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 2)
            .tint(.adaptiveBlack)
          
    }
         
            
            
   
     
    }
    
  


struct TextFieldModifier: ViewModifier {
 

    var isError: Bool
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 16)
            .textFieldStyle(.plain)
            .foregroundColor(.adaptiveBlack)
            .frame(height: 50)
            .cornerRadius(2)
            .accessibilityAddTraits(.isHeader)
            .font(.caption)
            .overlay(
                
                RoundedRectangle(cornerRadius: 0)
                    .stroke(isError ? Color.red : Color.clear, lineWidth: isError ? 2 : 0)
            )
            .background(.adaptiveWhiteCard)
      
            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 2)
       
        
            .tint(.adaptiveBlack)
    }
    
    
            
   
     
    
    
  
}

    let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    return formatter
}()

