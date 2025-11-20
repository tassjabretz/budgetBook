//
//  CategoryFunctions.swift
//  savingPot
//
//  Created by Tassja Bretz on 18.10.25.
//

import Foundation
import SwiftData

final class BudgetBookFunctions {
    
    func fetchBudgetBooks(modelContext: ModelContext) -> [BudgetBook]  {
        
        
        do {
            let descriptor = FetchDescriptor<BudgetBook>()
            return try modelContext.fetch(descriptor)
            
        } catch {
            print("Fehler beim Abrufen der Kategorien : \(error)")
        }
        return []
    }
    
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
    
    
    func addBudgetBook (modelContext: ModelContext, budgetBookTitel: String)  {
        
        let budgetBook = BudgetBook(titel: budgetBookTitel)
        
        modelContext.insert(budgetBook)
        
        do {
            try modelContext.save()
            print("Context saved successfully")
        } catch {
            
            print("Error saving context: \(error)")
        }
        
        
        
    }
    
    func validateBudgetBook (budgetBooks:[BudgetBook], newBudgetBookTitel: String) -> Bool {
       
        if newBudgetBookTitel == "Standard" || newBudgetBookTitel.isEmpty {
            return false
        }
        
       
        for budgetBook in budgetBooks {
            if budgetBook.titel == newBudgetBookTitel {
                return false
            }
        }
        
        return true
    }
        
        

    
}
