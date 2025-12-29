//
//  CategoryFunctions.swift
//  savingPot
//
//  Created by Tassja Bretz on 18.10.25.
//

import Foundation
import SwiftData

final class TransactionFunctions {
    
    func deleteTransaction(modelContext: ModelContext, transaction: Transaction, completion: @escaping (Error?) -> Void) {
        guard transaction.modelContext != nil else {
            let error = NSError(
                domain: "TransactionError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Transaktion existiert nicht mehr."]
            )
            completion(error)
            return
        }

        do {
            modelContext.delete(transaction)
            try modelContext.save()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func editTransaction(
        modelContext: ModelContext,
        transaction: Transaction,
        newCategoryKey: String,
        newTitel: String,
        newDescription: String,
        newAmount: Double,
        newType: Transaction.TransactionType,
        completion: @escaping (Error?) -> Void
    ) {
        do {
            let newIsOutgoing = (newType == .outcome)
            
         
            let categoryDescriptor = FetchDescriptor<Category>(
                predicate: #Predicate { $0.categoryName == newCategoryKey && $0.isOutgoing == newIsOutgoing }
            )
            
            guard let newCategory = try modelContext.fetch(categoryDescriptor).first else {
                
                throw NSError(domain: "TransactionEditError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kategorie mit Schlüssel '\(newCategoryKey)' nicht gefunden."])
            }
            
          
       
            

            transaction.titel = newTitel
            transaction.text = newDescription
            transaction.amount = newAmount
            transaction.type = newType
            transaction.category = newCategory
            
            try modelContext.save()
            completion(nil) 
            
        } catch {
            completion(error)
        }
    }
    
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
    
    
    func addTransaction(
        modelContext: ModelContext,
        categoryName: String,
        transactionTitel: String,
        description: String,
        amount: Double,
        transactionType: Transaction.TransactionType,
        completion: @escaping (Error?) -> Void
    ) {
        do {
           
            let descriptorCategory = FetchDescriptor<Category>(
                predicate: #Predicate { $0.categoryName == categoryName }
            )
            guard let category = try modelContext.fetch(descriptorCategory).first else {
                print("Error: Category with name '\(categoryName)' not found.")
                return
            }
            let transaction = Transaction(
                titel: transactionTitel,
                text: description,
                amount: amount,
                type: transactionType,
                category: category
            )
            
            
            modelContext.insert(transaction)
            
            try modelContext.save()
            
            
            completion(nil)
            
            
            
        } catch {
            completion(error)
        }
    }
    
    func validateTransaction(categoryName: String, transactionTitel: String, description: String, amount: Double) -> Bool {
        
        let areFieldsValid = !categoryName.isEmpty &&
                             !transactionTitel.isEmpty &&
                             !description.isEmpty &&
                             amount > 0.0
        
        return areFieldsValid 
    }
}
