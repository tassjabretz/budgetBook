//
//  TextModifiers.swift
//  savingPot
//
//  Created by Tassja Bretz on 17.10.25.
//

import Foundation
import SwiftUI

struct TextFieldModifier: ViewModifier {
 

    @FocusState private var fieldIsFocused: Bool
    func body(content: Content) -> some View {
        content
            .frame(height: 55)
            .textFieldStyle(PlainTextFieldStyle())
            .padding([.horizontal], 4)
            .padding(.vertical, 5)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(fieldIsFocused ? Color.blue : Color.gray, lineWidth: 2))
            .focused($fieldIsFocused)
            
   
     
    }
    
  
}
