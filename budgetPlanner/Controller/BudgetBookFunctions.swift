

import Foundation
import SwiftData

final class BudgetBookFunctions {
    
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
    
    /**
     This function add the BudgetBook "Standard" to the Model BudgetBook
     */
    func applyBudgetBook (modelContext: ModelContext)  {
        
        let budgetBook = BudgetBook(titel: "Standard")
        
        modelContext.insert(budgetBook)
        
        do {
            try modelContext.save()
            print("Context saved successfully")
        } catch {
            
            print("Error saving context: \(error)")
        }
        
        
    }
    
}
