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
                    .init(\.id)
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
                        .init(\.id)
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
        Category(categoryName: "miete", iconName: "house", budget: 5000, isOutgoing: true),
        Category(categoryName: "kredit", iconName: "creditcard", budget: 200, isOutgoing: true),
        Category(categoryName: "lebensmittel", iconName: "carrot", budget: 400, isOutgoing: true),
        Category(categoryName: "drogerie", iconName: "cart", budget: 30, isOutgoing: true),
        Category(categoryName: "restaurant", iconName: "fork.knife", budget: 100, isOutgoing: true),
        Category(categoryName: "handy", iconName: "smartphone", budget: 50, isOutgoing: true),
        Category(categoryName: "internet", iconName: "wifi", budget: 50, isOutgoing: true),
        Category(categoryName: "sport", iconName: "figure.badminton", budget: 50, isOutgoing: true),
        Category(categoryName: "special", iconName: "plus", budget: 40, isOutgoing: true),
        Category(categoryName: "gehalt", iconName: "banknote", budget: 0, isOutgoing: false),
    ]
    
    for category in categories {
        modelContext.insert(category)
    }
    do {
        try modelContext.save()
        print("Context saved successfully") // And this line
    } catch {
        
        print("Error saving context: \(error)")
    }
    
    
}
  }
