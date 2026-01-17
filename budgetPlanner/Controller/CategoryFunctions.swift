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
                    .init(\.categoryName, order: .forward)
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
                    .init(\.categoryName, order: .forward)
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
                    .init(\.categoryName, order: .forward)
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
      
            Category(categoryName: "shopping", iconName: "carrot", defaultBudget: 200, isOutgoing: true),
            Category(categoryName: "restaurant", iconName: "fork.knife", defaultBudget: 100, isOutgoing: true),
            Category(categoryName: "handy", iconName: "smartphone", defaultBudget: 25, isOutgoing: true),
            Category(categoryName: "sport", iconName: "figure.badminton", defaultBudget: 35, isOutgoing: true),
            Category(categoryName: "learn", iconName: "book", defaultBudget: 20, isOutgoing: true),
            Category(categoryName: "beauty", iconName: "bathtub", defaultBudget: 45, isOutgoing: true),
            Category(categoryName: "transport", iconName: "bus", defaultBudget: 63, isOutgoing: true),
            Category(categoryName: "clothing", iconName: "jacket", defaultBudget: 100, isOutgoing: true),
            Category(categoryName: "car", iconName: "car", defaultBudget: 400, isOutgoing: true),
            Category(categoryName: "drink", iconName: "waterbottle", defaultBudget: 40, isOutgoing: true),
            Category(categoryName: "electronics", iconName: "laptopcomputer", defaultBudget: 60, isOutgoing: true),
            Category(categoryName: "travel", iconName: "airplane", defaultBudget: 100, isOutgoing: true),
            Category(categoryName: "health", iconName: "cross.case", defaultBudget: 72, isOutgoing: true),
            Category(categoryName: "pets", iconName: "dog", defaultBudget: 50, isOutgoing: true),
            Category(categoryName: "repair", iconName: "wrench.adjustable", defaultBudget: 100, isOutgoing: true),
            Category(categoryName: "home", iconName: "sofa", defaultBudget: 80, isOutgoing: true),
            Category(categoryName: "rent", iconName: "house", defaultBudget: 1000, isOutgoing: true),
            Category(categoryName: "familiy_friends", iconName: "person.2",  defaultBudget: 50, isOutgoing: true),
            Category(categoryName: "special", iconName: "plus",  defaultBudget: 30.00, isOutgoing: true),
  
            Category(categoryName: "credit", iconName: "eurosign.bank.building", defaultBudget: 200, isOutgoing: true),
            Category(categoryName: "party", iconName: "music.microphone", defaultBudget: 100, isOutgoing: true),
            Category(categoryName: "familiy_friends", iconName: "person.crop.circle.badge.plus",  defaultBudget: 0.0, isOutgoing: false),
            Category(categoryName: "salary", iconName: "banknote",  defaultBudget: 0.0, isOutgoing: false),
            Category(categoryName: "investment", iconName: "eurosign",  defaultBudget: 0.0, isOutgoing: false),
            Category(categoryName: "special", iconName: "questionmark",  defaultBudget: 0.0, isOutgoing: false),
    
       
      
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
    
    func saveAllCategories(
        modelContext: ModelContext,
        completion: @escaping (Error?) -> Void
    ) {
        do {
            if modelContext.hasChanges {
                try modelContext.save()
            }
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
        
        func checkAndResetMonthlyBudget(modelContext: ModelContext, currentDate: Date = .now) {
            
            let outcomeCategories: [Category] = CategoryFunctions().fetchCategories(modelContext: modelContext)
            
            let calendar = Calendar.current
            let month = calendar.component(.month, from: currentDate)
            let year = calendar.component(.year, from: currentDate)
            
            
            let lastResetKey = "lastBudgetResetDate"
            let lastResetIdentifier = UserDefaults.standard.string(forKey: lastResetKey) ?? ""
            let currentIdentifier = "\(month)-\(year)"
            
            
            if lastResetIdentifier != currentIdentifier {
                for category in outcomeCategories {
                    category.currentBudget = category.defaultBudget
                }
                
                UserDefaults.standard.set(currentIdentifier, forKey: lastResetKey)
                try? modelContext.save()
                
            }
        }
    }
    
    
    

