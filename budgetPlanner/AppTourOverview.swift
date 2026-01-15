//
//  AppTour.swift
//  savingPot
//
//  Created by Tassja Bretz on 09.01.26.
//

import SwiftUI

struct AppTour: View {
    var body: some View {
        
        
        
        VStack {
            HStack {
                Spacer()
                roundImage(imageName:"xmark")
                    .padding()
               
           
            }
           
            .padding()
   
            ImageAppTour(imageName: "overview")
            Text("Habe alle deine Ein und Ausgaben im Blick")
                .font(.headline)
            
           
        }
        .padding()
        .foregroundStyle(.adaptiveBlack)
       
        
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(.adaptiveWhiteBackground))
    }
}

#Preview {
    AppTour()
}
