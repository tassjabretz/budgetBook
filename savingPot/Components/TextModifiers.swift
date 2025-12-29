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
            .padding([.horizontal], 4)
            .padding(.vertical, 5)
            .background(Color(.white))
            .cornerRadius(2)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(isError ? Color.red : Color.clear, lineWidth: isError ? 2 : 0)
            )
            .font(.caption)
    }
         
            
            
   
     
    }
    
  


struct TextFieldModifier: ViewModifier {
 

    var isError: Bool
    func body(content: Content) -> some View {
        content

            .textFieldStyle(.plain)
            .foregroundColor(.black)
            .frame(height: 30)
            .cornerRadius(2)
            .accessibilityAddTraits(.isHeader)
            .font(.caption)
            .overlay(
                
                RoundedRectangle(cornerRadius: 0)
                    .stroke(isError ? Color.red : Color.clear, lineWidth: isError ? 2 : 0)
            )
            .background(Color.white)
            .foregroundColor(.black)
        
    }
    
    
            
   
     
    
    
  
}

    let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale.current
    return formatter
}()

