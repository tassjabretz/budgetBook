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
        sut = TransactionFunctions()
    }
    
    override func tearDown() {
        sut = nil
        container = nil
        context = nil
        super.tearDown()
    }
    func testAddTransaction_ShouldIncreaseCount_error() async throws {
        
        let categoryName = "Sonstiges"
        let title = "Test Kauf"
        let amount = 19.99
        let type = Transaction.TransactionType.outcome
        
        
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        context.insert(testCategory)
        try? context.save()
        
        
        
        sut.addTransaction(
            modelContext: context,
            categoryName: categoryName,
            transactionTitel: title,
            description: "Test Beschreibung",
            amount: amount,
            transactionType: type
        ) { error in
            XCTAssertNotNil(error, "Es sollte kein Fehler auftreten")
            
        }
        
        
        
        
        let descriptor = FetchDescriptor<Transaction>()
        let results = try? context.fetch(descriptor)
        
        XCTAssertEqual(results?.count, 0)
    }
    
    func testAddTransaction_ShouldIncreaseCount() async throws {
        
        let categoryName = "Drogerie"
        let title = "Test Kauf"
        let amount = 19.99
        let type = Transaction.TransactionType.outcome
        
        
        let testCategory = Category(categoryName: categoryName, iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        context.insert(testCategory)
        try context.save()
        
        let expectation = XCTestExpectation(description: "Completion handler called")
        
        sut.addTransaction(
            modelContext: context,
            categoryName: categoryName,
            transactionTitel: title,
            description: "Test Beschreibung",
            amount: amount,
            transactionType: type
        ) { error in
            XCTAssertNil(error, "Es sollte kein Fehler auftreten")
            expectation.fulfill( )
            
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        
        let descriptor = FetchDescriptor<Transaction>()
        let results = try? context.fetch(descriptor)
        
       
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.titel, title)
        XCTAssertEqual(results?.first?.category?.categoryName, categoryName)
    }
    
    func testDeleteTransaction() async throws{
        
        let categoryName = "Drogerie"
        
        let testCategory = Category(categoryName: categoryName, iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        let transactionToDelete = Transaction(
            titel: "Miete",
            text: "Monatlich",
            amount: 800.0,
            type: Transaction.TransactionType.outcome
        )
        
        let expectation = XCTestExpectation(description: "Completion handler called")
        
        context.insert(testCategory)
        context.insert(transactionToDelete)
        try context.save()
        
        sut.deleteTransaction(modelContext: context, transaction: transactionToDelete, newCategoryKey: "Drogerie") { error in
            XCTAssertNil(error, "Es sollte kein Fehler beim Löschen auftreten")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        let results = try context.fetch(FetchDescriptor<Transaction>())
        XCTAssertEqual(results.count, 0, "Die Transaktion sollte erfolgreich gelöscht worden sein.")
    }
    
    func testDeleteTransaction_fail() async throws{
        
        let transactionToDeleteError = Transaction(
            titel: "Miete",
            text: "Monatlich",
            amount: 800.0,
            type: .outcome
        )
        context.insert(transactionToDeleteError)
        try context.save()
        
        context.delete(transactionToDeleteError)
        try context.save()
        
        
        let expectation = expectation(description: "Sollte einen Fehler im Callback liefern")
        
        
        sut.deleteTransaction(modelContext: context, transaction: transactionToDeleteError, newCategoryKey: "Test") { error in
            
            XCTAssertNotNil(error, "Es sollte ein Fehler auftreten, wenn die Transaktion nicht existiert.")
            
            
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testFetchTransactions() async throws {
        
        let transactionToDelete = Transaction(
            titel: "Miete",
            text: "Monatlich",
            amount: 800.0,
            type: .outcome
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
        
        let transaction = Transaction(titel: "Döner", text: "Mittagessen", amount: 7.50, type: .outcome, category: category)
        context.insert(transaction)
        try context.save()
        
        
        let newTitle = "Kino"
        let newAmount = 15.0
        let newType = Transaction.TransactionType.outcome
        
        let expectation = XCTestExpectation(description: "Completion handler called")
        
        
        sut.editTransaction(
            modelContext: context,
            transaction: transaction,
            newCategoryKey: newCategory.categoryName,
            newTitel: newTitle,
            newDescription: "Abendgestaltung",
            newAmount: newAmount,
            newType: newType
        ) { error in
            XCTAssertNil(error, "Es sollte kein Fehler beim Editieren auftreten")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertEqual(transaction.titel, newTitle)
        XCTAssertEqual(transaction.amount, newAmount)
        XCTAssertEqual(transaction.category?.categoryName, "Freizeit")
        
    }
    
    func testEditTransaction_fail() async throws {
        
        let category = Category(categoryName: "Essen", iconName: "fork.knife", defaultBudget: 100.0, isOutgoing: true)
        context.insert(category)
        try context.save()
        
        
        let transaction = Transaction(titel: "Döner", text: "Mittagessen", amount: 7.50, type: .outcome)
        context.insert(transaction)
        
        let expectation = XCTestExpectation(description: "Sollte einen Fehler liefern")
        
            sut.editTransaction(
            modelContext: context,
            transaction: transaction,
            newCategoryKey: "NichtExistierendeKategorie",
            newTitel: "Kino",
            newDescription: "Abendgestaltung",
            newAmount: 15.0,
            newType: .outcome
        ) { error in
            XCTAssertNotNil(error, "Der Test sollte fehlschlagen, weil die Kategorie fehlt")
            expectation.fulfill()
        }
        
    }
    func testEditTransaction_changeTransactionType() async throws {
        
        let categoryOutcome = Category(categoryName: "Essen", iconName: "fork.knife", defaultBudget: 100.0, isOutgoing: true)
        let categoryIncome = Category(categoryName: "Freunde", iconName: "star", defaultBudget: 0.0, isOutgoing: false)
        context.insert(categoryOutcome)
        context.insert(categoryIncome)
        
        let transaction = Transaction(titel: "Döner", text: "Mittagessen", amount: 10.00, type: .outcome, category: categoryOutcome)
        
        context.insert(transaction)
        try context.save()
        
        let newAmount = 15.0
        let newType = Transaction.TransactionType.income
        let expectation = XCTestExpectation(description: "Completion handler called")
     
            sut.editTransaction(
            modelContext: context,
            transaction: transaction,
            newCategoryKey: "Freunde",
            newTitel: transaction.titel,
            newDescription: transaction.text,
            newAmount: newAmount,
            newType: newType
        ) { error in
            XCTAssertNil(error, "Es sollte kein Fehler beim Editieren auftreten")
            expectation.fulfill()
            
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
        
        
        XCTAssertEqual(categoryOutcome.currentBudget, 100.0)
        XCTAssertEqual(categoryIncome.currentBudget, 15.0)
        

    }
    func testEditTransaction_ChangeCategory() async throws {
   
        let category = Category(categoryName: "Essen", iconName: "fork.knife", defaultBudget: 100.0, isOutgoing: true)
        let newCategory = Category(categoryName: "Freizeit", iconName: "star", defaultBudget: 50.0, isOutgoing: true)
        
        category.currentBudget = 92.0
        
        context.insert(category)
        context.insert(newCategory)
        
        let transaction = Transaction(titel: "Döner", text: "Mittagessen", amount: 8.00, type: .outcome, category: category)
        context.insert(transaction)
        try context.save()
        
     
        let expectation = XCTestExpectation(description: "Edit transaction completion")

     
        sut.editTransaction(
            modelContext: context,
            transaction: transaction,
            newCategoryKey: newCategory.categoryName,
            newTitel: transaction.titel,
            newDescription: "Döner",
            newAmount: transaction.amount,
            newType: transaction.type
        ) { error in
            XCTAssertNil(error, "Es sollte kein Fehler beim Editieren auftreten")
            expectation.fulfill()
        }
        
      
        await fulfillment(of: [expectation], timeout: 2.0)

      
        XCTAssertEqual(category.currentBudget, 100.0, "Das Budget der alten Kategorie wurde nicht zurückgesetzt")
        XCTAssertEqual(newCategory.currentBudget, 42.0, "Das Budget der neuen Kategorie wurde nicht korrekt berechnet")
    }
}
