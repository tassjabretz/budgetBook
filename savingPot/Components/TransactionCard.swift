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
                HStack (alignment:.center)
                {
                    
                    Image(systemName: transaction.category!.iconName)
                        .renderingMode(.template)
                            .resizable()
                            .modifier(roundImage())
                           
                            
                    
                   
           Spacer()
                   
                    VStack(alignment: .leading)
                    {
                     
                        Text(transaction.titel)
                            .fontWeight(.bold)
                        Text(transaction.text)
                        let rawName = transaction.category?.categoryName ?? "Unknown"
                        let categoryName = NSLocalizedString(rawName, comment: "The display name for the transaction category")
                        Text(categoryName)
                        
                            
                    }
                    .font(.caption)
                    .foregroundStyle(.adaptiveBlack)
                    .frame(width: 120, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    
                    Spacer()
                    if(transaction.type == .income)
                    {
                        Capsule()
                            .fill(Color(.green))
                            .frame(width: 100, height: 30)
                            .overlay(
                                Text("+" + String(transaction.amount) + "€")
                                    .foregroundStyle(Color.white)
                                    .font(.caption)
                            )
                    }
                    else if (transaction.type == .outcome)
                    {
                        Capsule()
                            .fill(Color(.darkred))
                            .frame(width: 100, height: 30)
                            .overlay(
                                Text("-" + String(transaction.amount) + "€")
                                    .foregroundStyle(Color.white)
                                    .font(.caption2)
                            )
                    }
                }
                .foregroundStyle(.adaptiveBlack)
            }
            
            .padding()
            .font(.caption)
            .frame(height: 60)
           
            
   
        
    }
}


#Preview {
    
    
    
    let sampleCategory = Category(
        categoryName: "Familie und Freunde",
        iconName: "house.fill",
        budget: 100.0,
        isOutgoing: true,
    )
    
    let sampleCategory2 = Category(
        categoryName: "Freunde",
        iconName: "house.fill",
        budget: 100.0,
        isOutgoing: true,
    )
    
    
    
    let sampleTransaction = Transaction(
        titel: "Tassja",
        text: "Test",
        amount: 2.0,
        type: .outcome,
        category: sampleCategory
    )
    
    
    let sampleTransaction2 = Transaction(
        titel: "Tassja",
        text: "Test",
        amount: 2.0,
        type: .outcome,
        category: sampleCategory2
    )
    
    
    
    
    TransactionCard(transaction: sampleTransaction)
    TransactionCard(transaction: sampleTransaction2)

}

