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
 
    @State private var isError: Bool = false
    @State private var showToast: Bool = false
    @State private var message: String?
    @Environment(\.modelContext) var modelContext
    
    @State private var categories: [Category] = []
    @Binding var selectedTab: Int

    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            if(isOutcome)
            {
                ForEach(categories) { category in
                    CategoryRow(
                        isOutcome: category.isOutgoing,
                        category: category,
                        selectedTab: $selectedTab,
                        onSave: { message in
                            self.message = message
                            withAnimation {
                                self.showToast = true
                            }
                        }
                    )
                }
            }
            else
            {
                ForEach(categories) { category in
                        CategoryRow(
                            isOutcome: category.isOutgoing,
                            category: category,
                            selectedTab: $selectedTab,
                            onSave: { message in
                                self.message = message
                                withAnimation {
                                    self.showToast = true
                                }
                            }
                        )
                
                    
                }
                
                
            }
        }
        .toast(isShowing: $showToast, message: message ?? "")
        
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
                    .foregroundColor(.adaptiveBlack)
                    .font(.headline)
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
    Categories(isOutcome: true, selectedTab: .constant(0))
}
