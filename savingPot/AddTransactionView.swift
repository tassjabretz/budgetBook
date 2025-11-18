//
//  Home.swift
//  savingPot
//
//  Created by Tassja Bretz on 02.10.25.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    
    
    @State var titel = ""
    
    
    @State var text = ""
    @State  var amount: Double = 0.0
    @State  var isError = false
    
    @State private var description: String = ""
    let placeholderText = NSLocalizedString("description", comment: "test")
    
    
    @Environment(\.modelContext) var modelContext
    @State var categories: [Category] = []
    @State var budgetBooks: [BudgetBook] = []
    
    var transaktionstypes: [String] = ["Einnahme", "Ausgabe"]
    @State private var selectedType = "Einnahme"
    
   
    
   

    @State private var selectedCategory = ""
    @State private var selectedBudgetBook = ""
    var body: some View {
        
        

            
            VStack(alignment: .leading) {
                
                Group {
                    TextField("transaction_title_placeholder", text: $titel)
                        .textFieldStyle(.roundedBorder)
                    
                    TextField(placeholderText, text: $text,  axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5...10)
                        .background(Color.white)
                    
                    
                    
                    
                    TextField("amount", value: $amount, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                }
                
                Group {
                VStack(spacing: 0) {
                    
                    HStack {
                        
                        Text("Tranksaktionstyp")
                            .bold()
                        Picker("", selection: $selectedType) {
                            if transaktionstypes.isEmpty {
                                Text("No Categories").tag("")
                            }
                            else
                            {
                                ForEach(transaktionstypes, id: \.self) {
                                    Text($0)
                                    
                                }
                            }
                        }
                        .pickerStyle(.segmented)
                       
                    }
                    .padding(.top)
                    
                    
                    VStack (alignment: .leading){
                        
                        
                        HStack {
                            Text("select_category")
                                .bold()
                            Spacer()
                            Picker("select_category", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) {
                                    Text(LocalizedStringKey($0.categoryName))
                                        .tag($0.categoryName)
                                }
                            }
                            
                            
                        }
                    }
                        if(budgetBooks.count > 0)
                        {
                            HStack {
                                Text("budgetBook")
                                    .bold()
                                Spacer()
                                Picker("budgetBook", selection: $selectedBudgetBook) {
                                    ForEach(budgetBooks, id: \.self) {
                                        Text(LocalizedStringKey($0.titel))
                                            .tag($0.titel)
                                    }
                                }
                            }
                        }
                    }
                     .scrollContentBackground(.hidden)
                              
                    .accentColor(Color(.black))
                    
                    
                    Spacer()
                    
                    Button(action: saveTransaction) {
                        Text("add_transaction")
                            .modifier(ButtonNormal(buttonTitel: ""))
                    }
                   
               
                    .alert("please_fill_in_all_fields", isPresented: $isError) {
                                Button("OK", role: .cancel) { }
                            .background(Color.blueback)
                            }
                    
                    
                    .onChange(of: description) { newValue in
                        description = newValue
                    }
          
      
                    .onChange(of: budgetBooks) { oldValue, newValue in
                        if let firstbudgetBookName = newValue.first?.titel {
                            if selectedBudgetBook == "" {
                                selectedBudgetBook = firstbudgetBookName
                            }
                        }
                    }
                    
                    .onChange(of: categories) { oldValue, newValue in
                        if let firstCategoryName = newValue.first?.categoryName {
                            if selectedCategory == "" {
                                selectedCategory = firstCategoryName
                            }
                        }
                    }
                    .padding(.top)
                    
                }
                
         
                .task {
                    do {
                        let initialCheckCategory = try modelContext.fetch(FetchDescriptor<Category>())
                      
                        if initialCheckCategory.isEmpty {
                            CategoryFunctions().applyCategories(modelContext: modelContext)
                            
                        }
                     
                     
                    } catch {
                        print("Initial data check failed: \(error)")
                    }
                    categories = CategoryFunctions().fetchCategoriesOutcome(modelContext: modelContext)
                    budgetBooks = BudgetBookFunctions().fetchBudgetBooks(modelContext: modelContext)
                }
                
            
           
            }
            .overlay(loadingIndicators)
       
            .padding()
            
            .font(.system(size: 12))
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.lightblue)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("add_transaction")
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
    var loadingIndicators: some View {
        VStack {
            if categories.isEmpty {
                ProgressView("loading_categories")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .controlSize(.large)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
            }
            
            if budgetBooks.isEmpty {
                ProgressView("loading_budgteBooks")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .controlSize(.large)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
            }
        }
    }
    
    func saveTransaction() {
        
        // 1. Validate the transaction data
        let isValid = TransactionFunctions().validateTransaction(
            categoryName: selectedCategory,
            transactionTitel: titel,
            description: text, // Assuming 'text' is used for description as per previous suggestions
            amount: amount,
            budgeBookTitel: selectedBudgetBook
        )
        
        if isValid {
            // 2. Data is valid: Save the transaction
            TransactionFunctions().addTransaction(
                modelContext: modelContext,
                categoryName: selectedCategory,
                transactionTitel: titel,
                description: text, // Use 'text'
                amount: amount,
                transactionType: selectedType,
                budgeBookTitel: selectedBudgetBook
            )
            
         
            
        } else {
            // 4. Data is invalid: Show the error alert
            self.isError = true
        }
    }

}




#Preview {
    AddTransactionView()
}
