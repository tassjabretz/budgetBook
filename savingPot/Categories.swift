//
//  Home.swift
//  savingPot
//
//  Created by Tassja Bretz on 02.10.25.
//
import SwiftUI
import SwiftData


struct Categories: View {
    
    let isOutcome: Bool
    
    @Environment(\.modelContext) var modelContext
    
    @State private var categories: [Category] = []

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        return formatter
    }()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if(isOutcome)
            {
                ForEach(categories) { category in
                    CategoryRow(isOutcome: true, category: category, currencyFormatter: currencyFormatter)
                }
            }
            else
            {
                ForEach(categories) { category in
                    CategoryRow(isOutcome: false, category: category, currencyFormatter: currencyFormatter)
                    
                }
                
                
            }
        }
        .overlay {
            if categories.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                
            }
        }
        
        .task {
          
            do {
                let initialCheck = try modelContext.fetch(FetchDescriptor<Category>())
                if initialCheck.isEmpty {
                     CategoryFunctions().applyCategories(modelContext: modelContext)
                }
            } catch {
                print("Initial data check failed: \(error)")
            }
            
        
           
        }
        .onAppear {
            if(isOutcome)
            {
                categories = CategoryFunctions().fetchCategoriesOutcome(modelContext: modelContext)
            }
            else
            {
                categories = CategoryFunctions().fetchCategoriesIncome(modelContext: modelContext)
            }
            
        }
        
  
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.lightblue)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("kategorien")
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
    Categories(isOutcome: true)
}
