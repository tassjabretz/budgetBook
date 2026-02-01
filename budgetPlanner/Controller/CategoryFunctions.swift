import Foundation
import SwiftData

final class CategoryFunctions {
    static let shared = CategoryFunctions()
    private init() {}
    
    /**
     This function get all  available Outcome Categories as an array from Type Category
     */
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
    static func fetchCategoriesOutcome(modelContext: ModelContext) -> [Category] {
        shared.fetchCategoriesOutcome(modelContext: modelContext)
    }
    
    /**
     This function get all available Income Categories as an array from Type Category
     */
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
    static func fetchCategoriesIncome(modelContext: ModelContext) -> [Category] {
        shared.fetchCategoriesIncome(modelContext: modelContext)
    }
    
    /**
     This function get all  available Categories as an array from Type Category
     */
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
    static func fetchCategories(modelContext: ModelContext) -> [Category] {
        shared.fetchCategories(modelContext: modelContext)
    }
    
    
    /**
     This function set all available  Categories
     */
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
            Category(categoryName: "family_friends", iconName: "person.2",  defaultBudget: 50, isOutgoing: true),
            Category(categoryName: "special", iconName: "plus",  defaultBudget: 30.00, isOutgoing: true),
            
            Category(categoryName: "credit", iconName: "eurosign.bank.building", defaultBudget: 200, isOutgoing: true),
            Category(categoryName: "party", iconName: "music.microphone", defaultBudget: 100, isOutgoing: true),
            Category(categoryName: "family_friends", iconName: "person.crop.circle.badge.plus",  defaultBudget: 0.0, isOutgoing: false),
            Category(categoryName: "salary", iconName: "banknote",  defaultBudget: 0.0, isOutgoing: false),
            Category(categoryName: "investment", iconName: "eurosign",  defaultBudget: 0.0, isOutgoing: false),
            Category(categoryName: "special", iconName: "questionmark",  defaultBudget: 0.0, isOutgoing: false),
            
            Category(categoryName: "streaming", iconName: "tv.and.mediabox",  defaultBudget: 30, isOutgoing: true),
            Category(categoryName: "abo", iconName: "calendar.badge.plus",  defaultBudget: 30, isOutgoing: true),
            
            
            
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
    static func applyCategories(modelContext: ModelContext) {
        shared.applyCategories(modelContext: modelContext)
    }
    
    /**
     This function save the changes from all categories to the model
     */
    
    func saveAllCategories(modelContext: ModelContext)  throws {
        if modelContext.hasChanges {
            try modelContext.save()
        }
    }
    static func saveAllCategories(   modelContext: ModelContext) throws {
        try shared.saveAllCategories(modelContext: modelContext)
    }
    
    
    /**
     This function change the current Budget of a category after add a new transansaction
     */
    func setNewBudgetAfterNewTransaction (
        modelContext: ModelContext,
        category: Category,
        transaction: Transaction,
        
        
    ) {
        
        
        
        if(transaction.type == .expense)
        {
            category.currentBudget = category.currentBudget - transaction.amount
            
        }
        else
        
        {
            category.currentBudget = category.currentBudget + transaction.amount
        }
        
        
    }
    
    static func setNewBudgetAfterNewTransaction(   modelContext: ModelContext,
                                                   category: Category,
                                                   transaction: Transaction) {
        shared.setNewBudgetAfterNewTransaction(modelContext: modelContext, category: category, transaction: transaction)
    }
    
    
    
    
    
    
    
    /**
     This function change the current Budget of a category after edit a  transansaction
     */
    
    
    func setNewBudgetAfterEditTransaction(
        modelContext: ModelContext,
        oldCategory: Category,
        transaction: Transaction,
        newCategory: Category,
        newAmount: Double,
        newType: Transaction.TransactionType
    ) {
        
        if transaction.type == .expense {
            oldCategory.currentBudget += transaction.amount
        } else {
            oldCategory.currentBudget -= transaction.amount
        }
        
        
        oldCategory.currentBudget = min(oldCategory.currentBudget, oldCategory.defaultBudget)
        
        
        if newType == .expense {
            newCategory.currentBudget -= newAmount
            newCategory.currentBudget = min(newCategory.currentBudget, newCategory.defaultBudget)
        } else {
            newCategory.currentBudget += newAmount
            
        }
        
        
    }
    
    static func setNewBudgetAfterEditTransaction(  modelContext: ModelContext,
                                                   oldCategory: Category,
                                                   transaction: Transaction,
                                                   newCategory: Category,
                                                   newAmount: Double,
                                                   newType: Transaction.TransactionType) {
        shared.setNewBudgetAfterEditTransaction(modelContext: modelContext, oldCategory: oldCategory, transaction: transaction, newCategory: newCategory, newAmount: newAmount, newType: newType)
    }
    /**
     This function change the current Budget of a category after delete a  transansaction
     */
    func undoBudgetImpactBeforeDeletion(
        modelContext: ModelContext,
        category: Category,
        transaction: Transaction
    )  {
        
        if transaction.type == .expense {
            
            category.currentBudget += transaction.amount
        } else {
            
            category.currentBudget -= transaction.amount
        }
        
        
    }

    static func undoBudgetImpactBeforeDeletion(     modelContext: ModelContext,
                                                    category: Category,
                                                    transaction: Transaction) {
        shared.undoBudgetImpactBeforeDeletion(modelContext: modelContext, category: category, transaction: transaction)
    }
        
        /**
         This function set the default Budget to a providev value eyery first of Month
         */
        func checkAndResetMonthlyBudget(modelContext: ModelContext, currentDate: Date = .now) {
            
            let outcomeCategories: [Category] = CategoryFunctions.fetchCategories(modelContext: modelContext)
            
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
        static func checkAndResetMonthlyBudget(modelContext: ModelContext, currentDate: Date = .now) {
            shared.checkAndResetMonthlyBudget(modelContext: modelContext, currentDate: currentDate)
        }
        
    
}
   

