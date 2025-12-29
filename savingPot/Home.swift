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
    @Binding var selectedTab: Int

   
    var body: some View {

      
     
        ScrollView {
            
            if(transactions.isEmpty)
            {
       
                  
                EmptyView(selectedTab: $selectedTab)
                        .padding()
                    
                
            }
            else
            {
                VStack (alignment: .center) {
                  
                        HStack (alignment: .center)
                        {
                            Spacer()
                            Text("budgetBook")
                            Spacer()
                        }
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
    
                        
                        .padding()
                        
                        .background(
                            UnevenRoundedRectangle(
                                cornerRadii: .init(
                                    topLeading: 10,
                                    topTrailing: 10
                                ),
                                style: .continuous
                            )
                            .fill(Color.adaptiveGray)
                        )
                        
                        
                        ForEach(transactions.indices, id: \.self) { index in
                            let transaction = transactions[index]
                        
                            NavigationLink(destination: Edit(transaction: transaction, selectedTab: $selectedTab))
                            {
                                TransactionCard(transaction: transaction)
                                
                            }
              
                            
                            if index != transactions.count - 1 {
                                Divider()
                                    .frame(height: 1)
                                    .overlay(.adaptiveBlack)
                                
                            }
                        }
                       
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        
                            .stroke(Color.adaptiveBlack, lineWidth: 1)
                        
                        
                    )
               
                    
                    .padding()
               
                }
            
            
        }
        .task {
            transactions = TransactionFunctions().fetchTransactions(modelContext: modelContext)
            
           
            
        }
        
   
        
   
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.lightblue)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("budgetBook")
                    .foregroundColor(.adaptiveBlack)
                    .font(.title)
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
    Home(selectedTab: .constant(0))
}
