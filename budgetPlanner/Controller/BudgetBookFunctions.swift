

import Foundation
import SwiftData

final class BudgetBookFunctions {
    
    static let shared = BudgetBookFunctions()
    private init() {}
    
    /**
     This function return a array of all aviable Buget Books
     */
    func fetchBudgetBooks(modelContext: ModelContext) -> [BudgetBook]  {
        
        
        do {
            let descriptor = FetchDescriptor<BudgetBook>()
            return try modelContext.fetch(descriptor)
            
        } catch {
            print("Fehler beim Abrufen der Kategorien : \(error)")
        }
        return []
    }
    
    static func fetchBudgetBooks(modelContext: ModelContext) -> [BudgetBook] {
        shared.fetchBudgetBooks(modelContext: modelContext)
    }
    
    /**
     This function add the BudgetBook "Standard" to the Model BudgetBook
     */
    func applyBudgetBook (modelContext: ModelContext)  {
        
        let budgetBook = BudgetBook(title:"Standard")
        
        modelContext.insert(budgetBook)
        
        do {
            try modelContext.save()
            print("Context saved successfully")
        } catch {
            
            print("Error saving context: \(error)")
        }
        
        
    }
    
    static func applyBudgetBook(modelContext: ModelContext){
        shared.applyBudgetBook(modelContext: modelContext) 
    }
    
}
