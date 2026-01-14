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
        
        HStack(spacing: 15) {
            
            roundImage(imageName: transaction.category?.iconName ?? "questionmark")
      
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.titel).font(.headline).foregroundStyle(Color.gray)
                Text(transaction.text).font(.subheadline).foregroundColor(.secondary)
                Text(transaction.category?.categoryName ?? "Unbekannt").font(.caption2).foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text( String(transaction.amount) + " €")
                .font(.system(.body, design: .rounded))
                .bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(transaction.type  == .income ? Color.green : Color.red)
                .foregroundColor(.adaptiveWhiteBackground)
                .cornerRadius(8)
        }
        .padding()
        .background(.adaptiveWhiteCard)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 2)
    }
}


#Preview {
    
    
    
    let sampleCategory = Category(
        categoryName: "Familie und Freunde",
        iconName: "house.fill",
        defaultBudget: 100.0,
        isOutgoing: true,
    )
    
    let sampleCategory2 = Category(
        categoryName: "Gehalt",
        iconName: "pencil",
        defaultBudget: 100.0,
        isOutgoing: false,
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
        amount: 3000.0,
        type: .income,
        category: sampleCategory2
    )
    
    
    
    
    TransactionCard(transaction: sampleTransaction)
    TransactionCard(transaction: sampleTransaction2)

}

