//
//  savingPotTests.swift
//  savingPotTests
//
//  Created by Tassja Bretz on 02.10.25.
//

import XCTest
import SwiftData
@testable import budgetPlanner

@MainActor

final class TransactionTests: XCTestCase {
    
    var sut: TransactionFunctions!
    var container: ModelContainer!
    var context: ModelContext!
    
    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: Transaction.self, Category.self, configurations: config)
        context = ModelContext(container)
        sut = TransactionFunctions.shared
    }
    
    override func tearDown() {
        sut = nil
        container = nil
        context = nil
        super.tearDown()
    }
    
    func testAddTransaction_WithMissingCategory_ShouldThrowError() async throws {
        
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        context.insert(testCategory)
        try context.save()

        
        do {
            try await sut.addTransaction(
                modelContext: context,
                categoryName: "Sonstiges", // Existiert nicht!
                transactionTitel: "Test Kauf",
                description: "Test Beschreibung",
                amount: 19.99,
                transactionType: .expense
            )
            XCTFail("Die Funktion hätte einen Fehler werfen müssen, da die Kategorie fehlt.")
        } catch {
            let descriptor = FetchDescriptor<Transaction>()
            let results = try context.fetch(descriptor)
            
            
            XCTAssertEqual(results.count, 0, "Es darf keine Transaktion gespeichert werden, wenn die Kategorie fehlt.")
        }
    }
    
    func testAddTransaction_ShouldIncreaseCount() async throws {
        
        let categoryName = "Drogerie"
        let title = "Test Kauf"
        let amount = 19.99
        let type = Transaction.TransactionType.expense
        
        
        let testCategory = Category(categoryName: categoryName, iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        context.insert(testCategory)
        try context.save()
        
        
        
        try await sut.addTransaction(
            modelContext: context,
            categoryName: categoryName,
            transactionTitel: title,
            description: "Test Beschreibung",
            amount: amount,
            transactionType: type
        )
        
        
        
        
        let descriptor = FetchDescriptor<Transaction>()
        let results = try context.fetch(descriptor)
        
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, title)
        XCTAssertEqual(results.first?.category?.categoryName, categoryName)
    }
    
    func testDeleteTransaction() async throws{
        
        let categoryName = "Drogerie"
        
        let testCategory = Category(categoryName: categoryName, iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        let transactionToDelete = Transaction(
            title: "Miete",
            text: "Monatlich",
            amount: 800.0,
            type: Transaction.TransactionType.expense
        )
        
        
        
        context.insert(testCategory)
        context.insert(transactionToDelete)
        try context.save()
        
        
        try await sut.deleteTransaction(modelContext: context, transaction: transactionToDelete, newCategoryKey: "Drogerie")
        
        let results = try context.fetch(FetchDescriptor<Transaction>())
        XCTAssertEqual(results.count, 0, "Die Transaktion sollte erfolgreich gelöscht worden sein.")
    }
    
    func testDeleteTransaction_WhenAlreadyDeleted_ShouldThrowError() async throws {
        
        let transaction = Transaction(title: "Miete", text: "Monatlich", amount: 800.0, type: .expense)
        context.insert(transaction)
        try context.save()
        
       
        context.delete(transaction)
        try context.save()
        
        
        do {
            try await sut.deleteTransaction(modelContext: context, transaction: transaction, newCategoryKey: "Test")
            XCTFail("Die Funktion hätte einen Fehler werfen müssen, da die Transaktion bereits gelöscht war.")
        } catch {
           
            XCTAssertNotNil(error)
            print("Erwarteter Fehler gefangen: \(error.localizedDescription)")
        }
    }
    
    
    
    func testFetchTransactions() async throws {
        
        let transactionToDelete = Transaction(
            title: "Miete",
            text: "Monatlich",
            amount: 800.0,
            type: .expense
        )
        context.insert(transactionToDelete)
        try context.save()
        
        let results =  sut.fetchTransactions(modelContext: context)
        
        XCTAssertEqual(results.count, 1)
        
    }
    
    
    
    func testAddTransaction_Validate_false()  async throws {
        let categoryName = ""
        let title = "Test Kauf"
        let amount = 0.0
        let description = "Description"
        
        let result = sut.validateTransaction(categoryName: categoryName, transactionTitel: title, description: description, amount: amount)
        
        XCTAssertFalse(Bool(result))
        
    }
    
    func testAddTransaction_Validate_true() async {
        let categoryName = "Test"
        let title = "Test Kauf"
        let amount = 4.0
        let description = "Description"
        
        let result = sut.validateTransaction(categoryName: categoryName, transactionTitel: title, description: description, amount: amount)
        
        XCTAssertTrue(Bool(result))
        
    }
    
    func testEditTransaction_ShouldUpdateValues() async throws {
        
        let category = Category(categoryName: "Essen", iconName: "fork.knife", defaultBudget: 100.0, isOutgoing: true)
        let newCategory = Category(categoryName: "Freizeit", iconName: "star", defaultBudget: 50.0, isOutgoing: true)
        context.insert(category)
        context.insert(newCategory)
        
        let transaction = Transaction(title: "Döner", text: "Mittagessen", amount: 7.50, type: .expense, category: category)
        context.insert(transaction)
        try context.save()
        
        
        let newTitle = "Kino"
        let newAmount = 15.0
        let newType = Transaction.TransactionType.expense
        
       
        
        try await sut.editTransaction(
            modelContext: context,
            transaction: transaction,
            newCategoryKey: newCategory.categoryName,
            newTitel: newTitle,
            newDescription: "Abendgestaltung",
            newAmount: newAmount,
            newType: newType
        )
        
       
        
        XCTAssertEqual(transaction.title, newTitle)
        XCTAssertEqual(transaction.amount, newAmount)
        XCTAssertEqual(transaction.category?.categoryName, "Freizeit")
        
    }
    
    func testEditTransaction_WhenCategoryMissing_ShouldThrowErrorAndNotChangeData() async throws {
        // 1. Arrange: Initiale Daten erstellen
        let initialCategory = Category(categoryName: "Essen", iconName: "fork.knife", defaultBudget: 100.0, isOutgoing: true)
        context.insert(initialCategory)
        
        let transaction = Transaction(title: "Döner", text: "Mittagessen", amount: 7.50, type: .expense)
        transaction.category = initialCategory
        context.insert(transaction)
        try context.save()
        
        // 2. Act: Versuch, auf eine nicht existierende Kategorie zu ändern
        do {
            try await sut.editTransaction(
                modelContext: context,
                transaction: transaction,
                newCategoryKey: "NichtExistierendeKategorie", // Dieser Key existiert nicht
                newTitel: "Kino",
                newDescription: "Abendgestaltung",
                newAmount: 15.0,
                newType: .expense
            )
            XCTFail("Die Funktion hätte werfen müssen, da die neue Kategorie fehlt.")
        } catch {
            // 3. Assert: Prüfen, ob die Daten unverändert geblieben sind (Rollback-Zustand)
            // Wir holen die Transaktion frisch aus dem Context
            XCTAssertEqual(transaction.title, "Döner", "Der Titel sollte nicht geändert worden sein.")
            XCTAssertEqual(transaction.amount, 7.50, "Der Betrag sollte nicht geändert worden sein.")
            XCTAssertEqual(transaction.category?.categoryName, "Essen", "Die Kategorie sollte weiterhin 'Essen' sein.")
        }
    }
    
    func testEditTransaction_changeTransactionType() async throws {
        
        let categoryOutcome = Category(categoryName: "Essen", iconName: "fork.knife", defaultBudget: 100.0, isOutgoing: true)
        let categoryIncome = Category(categoryName: "Freunde", iconName: "star", defaultBudget: 0.0, isOutgoing: false)
        context.insert(categoryOutcome)
        context.insert(categoryIncome)
        
        let transaction = Transaction(title: "Döner", text: "Mittagessen", amount: 10.00, type: .expense, category: categoryOutcome)
        
        context.insert(transaction)
        try context.save()
        
        let newAmount = 15.0
        let newType = Transaction.TransactionType.income
   
        
        try await sut.editTransaction(
            modelContext: context,
            transaction: transaction,
            newCategoryKey: "Freunde",
            newTitel: transaction.title,
            newDescription: transaction.text,
            newAmount: newAmount,
            newType: newType
        )
        
        
        
        
        XCTAssertEqual(categoryOutcome.currentBudget, 100.0)
        XCTAssertEqual(categoryIncome.currentBudget, 15.0)
        
        
    }
    func testEditTransaction_ChangeCategory() async throws {
        
        let category = Category(categoryName: "Essen", iconName: "fork.knife", defaultBudget: 100.0, isOutgoing: true)
        let newCategory = Category(categoryName: "Freizeit", iconName: "star", defaultBudget: 50.0, isOutgoing: true)
        
        category.currentBudget = 92.0
        
        context.insert(category)
        context.insert(newCategory)
        
        let transaction = Transaction(title: "Döner", text: "Mittagessen", amount: 8.00, type: .expense, category: category)
        context.insert(transaction)
        try context.save()
        
        
        
        
        
        try await sut.editTransaction(
            modelContext: context,
            transaction: transaction,
            newCategoryKey: newCategory.categoryName,
            newTitel: transaction.title,
            newDescription: "Döner",
            newAmount: transaction.amount,
            newType: transaction.type
        )
        
        
        
        
        
        XCTAssertEqual(category.currentBudget, 100.0, "Das Budget der alten Kategorie wurde nicht zurückgesetzt")
        XCTAssertEqual(newCategory.currentBudget, 42.0, "Das Budget der neuen Kategorie wurde nicht korrekt berechnet")
    }
}

