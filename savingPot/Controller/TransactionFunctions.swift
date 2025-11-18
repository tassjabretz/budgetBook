//
//  CategoryFunctions.swift
//  savingPot
//
//  Created by Tassja Bretz on 18.10.25.
//

import Foundation
import SwiftData

final class TransactionFunctions {
    
    func fetchTransactions(modelContext: ModelContext) -> [Transaction]  {
        
        
        do {
            var descriptor = FetchDescriptor<Transaction>()
            
            descriptor.sortBy = [SortDescriptor(\Transaction.id, order: .reverse)]
            
            
            return try modelContext.fetch(descriptor)
            
        } catch {
            print("Fehler beim Abrufen der Transaktionen: \(error)")
        }
        return []
    }
    
    
    
    func addTransaction (modelContext: ModelContext, categoryName: String, transactionTitel: String,  description: String, amount: Double, transactionType: String, budgeBookTitel: String)  {
        
        
        do {
            let descriptorCategory = FetchDescriptor<Category>(
                predicate: #Predicate { $0.categoryName == categoryName})
            
            let descriptorbudgetBook = FetchDescriptor<BudgetBook>(
                predicate: #Predicate { $0.titel == budgeBookTitel })
            
            let category: Category = try! modelContext.fetch(descriptorCategory).first!
            let budgetBook = try! modelContext.fetch(descriptorbudgetBook).first!
            
            let transaction = Transaction(titel: transactionTitel,
                                          text: description,
                                          amount: amount,
                                          transactionType: transactionType,
                                          category: category,
                                          budgetBook: budgetBook)
            
            modelContext.insert(transaction)
            
            transaction.category = category
            
            category.transactions?.append(transaction)
            
            try modelContext.save()
            print("Context saved successfully")
        }
        catch {
            
            print("Error saving context: \(error)")
        }
    }
    
    func validateTransaction(categoryName: String, transactionTitel: String, description: String, amount: Double,budgeBookTitel: String) -> Bool {
        
        let areFieldsValid = !categoryName.isEmpty &&
        !transactionTitel.isEmpty &&
        !description.isEmpty &&
        !budgeBookTitel.isEmpty
        let isAmountValid = amount > 0.0
        
        return areFieldsValid && isAmountValid
    }
}
