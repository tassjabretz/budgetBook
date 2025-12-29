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
        Category(categoryName: "Miete", iconName: "house", budget: 5000, isOutgoing: true),
        Category(categoryName: "Kredit", iconName: "creditcard", budget: 200, isOutgoing: true),
        Category(categoryName: "Lebensmittel", iconName: "carrot", budget: 400, isOutgoing: true),
        Category(categoryName: "Drogerie", iconName: "cart", budget: 30, isOutgoing: true),
        Category(categoryName: "Restaurant", iconName: "fork.knife", budget: 100, isOutgoing: true),
        Category(categoryName: "Handy", iconName: "smartphone", budget: 50, isOutgoing: true),
        Category(categoryName: "Internet", iconName: "wifi", budget: 50, isOutgoing: true),
        Category(categoryName: "Sport", iconName: "figure.badminton", budget: 50, isOutgoing: true),
        Category(categoryName: "Special", iconName: "plus", budget: 40, isOutgoing: true),
        Category(categoryName: "salary", iconName: "banknote", budget: 0, isOutgoing: false),
        Category(categoryName: "familiy_friends", iconName: "person.crop.circle.badge.plus", budget: 0, isOutgoing: false),
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
            category.budget = newBudget
            
            try modelContext.save()
            completion(nil)
            
        } catch {
            completion(error)
        }
    }
  }
