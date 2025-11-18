//
//  Home.swift
//  savingPot
//
//  Created by Tassja Bretz on 02.10.25.
//

import SwiftUI

struct Settings: View {

    
    var body: some View {

        
            VStack(alignment: .leading) {
                
                NavigationLink(destination: Categories(isOutcome: true)) {
                    
                    
                    HStack (alignment: .center)
                    {
                        
                        Text("categories_outcome")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(Color(.black))
                    .padding()
                  
                   
                }
                Divider()
                    .frame(height: 1)
                    .overlay(.black)
                
                    
              
                NavigationLink(destination: Categories(isOutcome: false)) {
                    
                    
                    HStack(alignment: .center)
                    {
                        
                        Text("categories_income")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    
                    .foregroundStyle(Color(.black))
                    .padding()
                }
                
            }

            .overlay(
                RoundedRectangle(cornerRadius: 2)
                
                    .stroke(Color.black, lineWidth: 1)
                
                
            )
            
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.lightblue)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("einstellungen")
                        .foregroundColor(.black)
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                }
            }
            .toolbarBackground(
                Color.blueback,
                for: .navigationBar, .tabBar)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        
      
        
        
    }
    
}

#Preview {
    Settings()
}
