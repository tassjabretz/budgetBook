//
//  Home.swift
//  savingPot
//
//  Created by Tassja Bretz on 02.10.25.
//

import SwiftUI

struct Home: View {
    @Environment(\.modelContext) var modelContext
    @State var transactions: [Transaction] = []
    @State var budgetBooks: [BudgetBook] = []
    
    
    var body: some View {

      
     
        ScrollView {
            
            if(transactions.isEmpty)
            {
       
                  
                    EmptyView()
                        .padding()
                    
                
            }
            else
            {
         
                                    
                    
                    VStack {
                        
                        
                        
                        
                        
                        HStack
                        {
                            Text("Haushaltsbuch")
                            Spacer()
                            Image(systemName: "calendar")
                        }
                        
                        .padding()
                        
                        .background(
                            UnevenRoundedRectangle(
                                cornerRadii: .init(
                                    topLeading: 10,
                                    topTrailing: 10
                                ),
                                style: .continuous
                            )
                            .fill(Color.gray)
                        )
                        
                        
                        ForEach(transactions.indices, id: \.self) { index in
                            let transaction = transactions[index]
                            TransactionCard(transaction: transaction)
                            
                            
                            if index != transactions.count - 1 {
                                Divider()
                                    .frame(height: 1)
                                    .overlay(.black)
                                
                            }
                        }
                        Spacer()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        
                            .stroke(Color.black, lineWidth: 1)
                        
                        
                    )
                    
                    .padding()
                }
            
            
        }
        .task {
            transactions = TransactionFunctions().fetchTransactions(modelContext: modelContext)
            
            if(budgetBooks.isEmpty)
            {
                BudgetBookFunctions().applyBudgetBook(modelContext: modelContext)
                budgetBooks = BudgetBookFunctions().fetchBudgetBooks(modelContext: modelContext)
            }
            
        }
        
   
        
   
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.lightblue)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("haushalstbuch")
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
    Home()
}
