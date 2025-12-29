//
//  Home.swift
//  savingPot
//
//  Created by Tassja Bretz on 02.10.25.
//

import SwiftUI
import SwiftData

struct AddBudgetBookView: View {
    
    
    @State var titelBook = ""
    
    
    @State  var isErrorBook = false
    @State var budgetBooks: [BudgetBook] = []

    
    
    
    @Environment(\.modelContext) var modelContext

    
    var body: some View {
        
        
        
            
            VStack(alignment: .center) {
                
                
                TextField("budget_book_titel", text: $titelBook)
                    .textFieldStyle(.roundedBorder)
                    .padding(.bottom)
                    .font(.caption)
                
                Button(action: saveBudgetBook) {
                    Text("add_book")
                        .modifier(ButtonNormal(buttonTitel: ""))
                        .font(.title2)
                }
               
           
                .alert("please_fill_in_all_fields", isPresented: $isErrorBook) {
                            Button("OK", role: .cancel) { }
                        .background(Color.blueback)
                        }
               
      
                Spacer()
                
                Image(systemName: "plus.diamond.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .foregroundStyle(.blueback)

                Spacer()
              
               
            }
            .task {
                budgetBooks = BudgetBookFunctions().fetchBudgetBooks(modelContext: modelContext)
            }
          
        
       
            .padding()
            
            .font(.title3)
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.lightblue)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("add_book")
                        .foregroundColor(.black)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .toolbarBackground(
                Color.blueback,
                for: .navigationBar, .tabBar)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
            
            
        
     
 
        
    }
    
    func saveBudgetBook() {
        
        if(BudgetBookFunctions().validateBudgetBook(budgetBooks: budgetBooks, newBudgetBookTitel: titelBook) == false)
        {
            isErrorBook = true
        }
        else
        {
            BudgetBookFunctions().addBudgetBook(modelContext: modelContext, budgetBookTitel: titelBook)
        }
    }

}


#Preview {
    AddBudgetBookView()
}

