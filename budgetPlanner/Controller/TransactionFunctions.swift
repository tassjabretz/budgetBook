import Foundation
import SwiftData

final class TransactionFunctions {
    
    static let shared = TransactionFunctions()
    private  init() {}
    
    
    /**
     This function delete a selected transaction from the  model
     */
    
    func deleteTransaction(modelContext: ModelContext, transaction: Transaction, newCategoryKey: String) async throws {
        
        guard transaction.modelContext != nil else {
            throw NSError(
                domain: "TransactionError",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Transaktion existiert nicht mehr."]
            )
        }

        let categoryDescriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.categoryName == newCategoryKey }
        )

        guard let newCategory = try modelContext.fetch(categoryDescriptor).first else {
            throw NSError(domain: "TransactionEditError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kategorie nicht gefunden."])
        }

        CategoryFunctions.undoBudgetImpactBeforeDeletion(modelContext: modelContext, category: newCategory, transaction: transaction )
        modelContext.delete(transaction)
        try modelContext.save()
    }
    static func deleteTransaction(modelContext: ModelContext, transaction: Transaction, newCategoryKey: String) async throws {
        try await shared.deleteTransaction(modelContext: modelContext, transaction: transaction, newCategoryKey: newCategoryKey)
    }
    
    /**
     This function edit a selected transaction from the  model
     */
    
    func editTransaction(
        modelContext: ModelContext,
        transaction: Transaction,
        newCategoryKey: String,
        newTitel: String,
        newDescription: String,
        newAmount: Double,
        newType: Transaction.TransactionType
    ) async throws {
        guard let oldCategory = transaction.category else {
            throw NSError(domain: "TransactionEditError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Alte Kategorie fehlt."])
        }

        let newIsOutgoing = (newType == .expense)

        let categoryDescriptor = FetchDescriptor<Category>(
            predicate: #Predicate { $0.categoryName == newCategoryKey && $0.isOutgoing == newIsOutgoing }
        )

        guard let newCategory = try modelContext.fetch(categoryDescriptor).first else {
            throw NSError(domain: "TransactionEditError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Kategorie nicht gefunden."])
        }

        CategoryFunctions.setNewBudgetAfterEditTransaction(
            modelContext: modelContext,
            oldCategory: oldCategory,
            transaction: transaction,
            newCategory: newCategory,
            newAmount: newAmount,
            newType: newType
        )

        transaction.title = newTitel
        transaction.text = newDescription
        transaction.amount = newAmount
        transaction.type = newType
        transaction.category = newCategory

        try modelContext.save()
    }
    
    static func editTransaction(
    modelContext: ModelContext,
    transaction: Transaction,
    newCategoryKey: String,
    newTitel: String,
    newDescription: String,
    newAmount: Double,
    newType: Transaction.TransactionType) async throws {
        try await shared.editTransaction(  modelContext: modelContext,
                                           transaction: transaction,
                                           newCategoryKey: newCategoryKey,
                                           newTitel: newTitel,
                                           newDescription: newDescription,
                                           newAmount: newAmount,
                                           newType: newType)
    }
    
    /**
     This function fetch all provided transactions as an array of Transaction
     */
    func fetchTransactions(modelContext: ModelContext) -> [Transaction]  {
        
        
        do {
            var descriptor = FetchDescriptor<Transaction>()
            
            descriptor.sortBy = [SortDescriptor(\Transaction.date, order: .reverse)]
            
            
            return try modelContext.fetch(descriptor)
            
        } catch {
            print("Fehler beim Abrufen der Transaktionen: \(error)")
        }
        return []
   
    }
    
    static func fetchTransactions(
    modelContext: ModelContext)  -> [Transaction] {
      shared.fetchTransactions( modelContext: modelContext)
                                           
    }
    
    
    /**
     This function add a transaction the  model
     */

    func addTransaction(
        modelContext: ModelContext,
        categoryName: String,
        transactionTitel: String,
        description: String,
        amount: Double,
        transactionType: Transaction.TransactionType
    ) async throws {
        let nameToSearch = categoryName

        let descriptorCategory = FetchDescriptor<Category>(
            predicate: #Predicate { $0.categoryName == nameToSearch }
        )

        guard let category = try modelContext.fetch(descriptorCategory).first else {
            throw NSError(domain: "Test", code: 404, userInfo: [NSLocalizedDescriptionKey: "Category not found"])
        }

        let transaction = Transaction(
            title: transactionTitel,
            text: description,
            amount: amount,
            type: transactionType,
        )

        modelContext.insert(transaction)
        transaction.category = category

        CategoryFunctions.setNewBudgetAfterNewTransaction(
            modelContext: modelContext,
            category: category,
            transaction: transaction
        )

        try modelContext.save()
    }
    
    static func addTransaction(
        modelContext: ModelContext,
        categoryName: String,
        transactionTitel: String,
        description: String,
        amount: Double,
        transactionType: Transaction.TransactionType) async throws {
           try await shared.addTransaction(modelContext: modelContext, categoryName: categoryName, transactionTitel: transactionTitel, description: description, amount: amount, transactionType: transactionType)
                                           
    }
    
    /**
     This function checks if a new transaction is valid before save it to the model
     */
    func validateTransaction(categoryName: String, transactionTitel: String, description: String, amount: Double) -> Bool {
        
        let areFieldsValid = !categoryName.isEmpty &&
                             !transactionTitel.isEmpty &&
                             !description.isEmpty &&
                             amount > 0.0
        
        return areFieldsValid 
    }
    static func validateTransaction(
        categoryName: String, transactionTitel: String, description: String, amount: Double) -> Bool {
          shared.validateTransaction(categoryName: categoryName, transactionTitel: transactionTitel, description: description, amount: amount)
                                           
    }

}

