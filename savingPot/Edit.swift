//
//  Home.swift
//  savingPot
//
//  Created by Tassja Bretz on 02.10.25.
//

import SwiftUI

struct Edit: View {
    @State var titel: String = "titel"
    
    var body: some View {
        
        VStack {
            
            VStack (alignment: .leading)
            {
           
                    Text("Transaktions Titel")
                    .font(.subheadline)
                    .fontWeight(.light)
                HStack {
                    
                    Text(titel)
                        .font(.system(size: 25))
                    Spacer()
                    Image(systemName: "pencil")
                        .onTapGesture {
                            titel = "neu"
                        }
                }
                Divider()
                    .modifier(Line())
             
          
            }
            .padding()
         
            VStack (alignment: .leading)
            {
           
                    Text("Beschreibung")
                    .font(.subheadline)
                    .fontWeight(.light)
                HStack {
                    
                    Text("Description")
                        .font(.system(size: 25))
                    Spacer()
                    Image(systemName: "pencil")
                }
                Divider()
                    .modifier(Line())
             
          
            }
            .padding()
            
         
            VStack (alignment: .leading)
            {
           
                    Text("Kategorie")
                    .font(.subheadline)
                    .fontWeight(.light)
                HStack {
                    
                    Text("Description")
                        .font(.system(size: 25))
                    Spacer()
                    Image(systemName: "pencil")
                }
                Divider()
                    .modifier(Line())
                
            
         
                Spacer()
             
          
            }
            .padding()
            
            HStack (alignment: .bottom) {
                Button(action: {}) {
                        
       
                     }
                .modifier(ButtonNormal(buttonTitel: "Transaktion speichern"))
                Spacer()
                Button(action: {}) {}
                .modifier(ButtonRed(buttonTitel: "Transaktion löshcen"))
                
            }
            .font(.system(size: 14))
            .padding()
            
   
            
        }
        

        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.blueback)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Transaktion bearbeiten")
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
            }
        }
        .toolbarBackground(
            Color.gray,
            for: .navigationBar, .tabBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        
        
    }
}
    

#Preview {
    Edit()
}
