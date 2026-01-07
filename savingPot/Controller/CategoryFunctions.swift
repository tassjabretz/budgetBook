//
//  CategoryFunctions.swift
//  savingPot
//
//  Created by Tassja Bretz on 18.10.25.
//

import Foundation
import SwiftData

final class CategoryFunctions {
    
    func fetchCategoriesOutcome(modelContext: ModelContext) -> [Category]  {
        
        
        do {
            
            let descriptor = FetchDescriptor<Category>(
                predicate: #Predicate { $0.isOutgoing == true },
                sortBy: [
                    .init(\.categoryName)
                ]
            )
            return try modelContext.fetch(descriptor)
            
        } catch {
            print("Fehler beim Abrufen der Kategorien: \(error)")
        }
        return []
    }
    
    func fetchCategoriesIncome(modelContext: ModelContext) -> [Category]  {
        
        
        do {
            
            let descriptor = FetchDescriptor<Category>(
                predicate: #Predicate { $0.isOutgoing == false },
                sortBy: [
                    .init(\.categoryName)
                ]
            )
            return try modelContext.fetch(descriptor)
            
        } catch {
            print("Fehler beim Abrufen der Kategorien: \(error)")
        }
        return []
    }
    
    func fetchCategories(modelContext: ModelContext) -> [Category]  {
        
        
        do {
            
            let descriptor = FetchDescriptor<Category>(
                sortBy: [
                    .init(\.categoryName)
                ]
            )
            return try modelContext.fetch(descriptor)
            
        } catch {
            print("Fehler beim Abrufen der Kategorien: \(error)")
        }
        return []
    }
    
    
    
    func applyCategories (modelContext: ModelContext)  {
        let categories = [
            Category(categoryName: "Miete", iconName: "house", defaultBudget: 1000, isOutgoing: true),
            Category(categoryName: "Kredit", iconName: "creditcard", defaultBudget: 200, isOutgoing: true),
            Category(categoryName: "Lebensmittel", iconName: "carrot", defaultBudget: 400, isOutgoing: true),
            Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 30, isOutgoing: true),
            Category(categoryName: "Restaurant", iconName: "fork.knife", defaultBudget: 100, isOutgoing: true),
            Category(categoryName: "Handy", iconName: "smartphone", defaultBudget: 50, isOutgoing: true),
            Category(categoryName: "Internet", iconName: "wifi", defaultBudget: 50, isOutgoing: true),
            Category(categoryName: "Sport", iconName: "figure.badminton", defaultBudget: 50, isOutgoing: true),
            Category(categoryName: "Special", iconName: "plus", defaultBudget: 40, isOutgoing: true),
            Category(categoryName: "salary", iconName: "banknote",defaultBudget: 0.0 ,isOutgoing: false),
            Category(categoryName: "familiy_friends", iconName: "person.crop.circle.badge.plus",  defaultBudget: 0.0, isOutgoing: false),
            Category(categoryName: "Special", iconName: "plus", defaultBudget: 0.0, isOutgoing: false),
        ]
        
        for category in categories {
            modelContext.insert(category)
        }
        do {
            try modelContext.save()
            print("Context saved successfully")
        } catch {
            
            print("Error saving context: \(error)")
        }
        
        
        
        
    }
    
    func editCategoryBudget(
        modelContext: ModelContext,
        category: Category,
        newBudget: Double,
        completion: @escaping (Error?) -> Void
    ) {
        do {
            category.currentBudget = newBudget
            
            try modelContext.save()
            completion(nil)
            
        } catch {
            completion(error)
        }
    }
    
    func setNewBudgetAfterNewTransaction (
        modelContext: ModelContext,
        category: Category,
        transaction: Transaction,
        
    ) {
        
        
        
        if(transaction.type == .outcome)
        {
            category.currentBudget = category.currentBudget - transaction.amount
            
        }
        else
        
        {
            category.currentBudget = category.currentBudget + transaction.amount
        }
        
        
        
    }
    
    func setNewBudgetAfterEditTransaction(
        modelContext: ModelContext,
        oldCategory: Category,
        transaction: Transaction,
        newCategory: Category,
        newAmount: Double,
        newType: Transaction.TransactionType
    ) {
        
        if transaction.type == .outcome {
            oldCategory.currentBudget += transaction.amount
        } else {
            oldCategory.currentBudget -= transaction.amount
        }
        
       
        oldCategory.currentBudget = min(oldCategory.currentBudget, oldCategory.defaultBudget)


        if newType == .outcome {
            newCategory.currentBudget -= newAmount
            newCategory.currentBudget = min(newCategory.currentBudget, newCategory.defaultBudget)
        } else {
            newCategory.currentBudget += newAmount
            //newCategory.currentBudget = newCategory.currentBudget
        }
        
       
    }
    func undoBudgetImpactBeforeDeletion(
        modelContext: ModelContext,
        category: Category,
        transaction: Transaction
    )  {
        
        if transaction.type == .outcome {
           
            category.currentBudget += transaction.amount
        } else {
            
            category.currentBudget -= transaction.amount
        }
        
        
    }
    
  
}
    

  
