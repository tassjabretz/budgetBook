//
//  TransactionCard.swift
//  savingPot
//
//  Created by Tassja Bretz on 03.10.25.
//

import SwiftUI

struct TransactionCard: View {
    
 let transaction: Transaction
    
    var body: some View {
        

            
            VStack (alignment: .leading)
            {
                HStack (alignment: .center)
                {
                    
                    Image(systemName: transaction.category!.iconName)
                            .resizable()
                            .modifier(roundImageOutcome())
                    
                   
                    
                    Spacer()
                    
                    VStack (alignment: .leading)
                    {
                        Text(transaction.titel)
                        Text(transaction.text)
                        Text(transaction.category!.categoryName)
                    }
                    Spacer()
                    
                    if(transaction.transactionType == "Einnahme")
                    {
                        Capsule()
                            .fill(Color(.green))
                            .frame(width: 100, height: 30)
                            .overlay(
                                Text("+" + String(transaction.amount) + "€")
                                    .foregroundStyle(Color.white)
                            )
                    }
                    else if (transaction.transactionType == "Ausgabe")
                    {
                        Capsule()
                            .fill(Color(.darkred))
                            .frame(width: 100, height: 30)
                            .overlay(
                                Text("-" + String(transaction.amount) + "€")
                                    .foregroundStyle(Color.white)
                            )
                    }
                }
            }
            
            .padding()
            .font(.system(size: 10))
            .frame(height: 40)
           
            
   
        
    }
}

#Preview {
   
}
