//
//  ResultView.swift
//  savingPot
//
//  Created by Tassja Bretz on 17.12.25.
//

import SwiftUI

struct ResultView: View {
    

    let message: String
    let text: String
    @Binding var selectedTab: Int

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var navigationManager: NavigationManager
    var body: some View {

        VStack() {
                Spacer()
                
                Image(systemName:"xmark.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.red)
                    .scaledToFit()
                    .padding(.bottom, 40)
             
                
                Text(text)
                    .font(.callout)
                
                Text(message)
                    .font(.caption)
                
                Spacer()
                Button {
                    dismiss() 
                } label: {
                    Text("to_overview")
                        .modifier(ButtonNormal(buttonTitel: "to_overview"))
                }
            }
            .padding()
       
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.lightblue)
        }
      
  
    
}

#Preview {
    ResultView(message: "Error", text: "Hello", selectedTab: .constant(0))
}
