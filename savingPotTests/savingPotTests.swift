//
//  savingPotTests.swift
//  savingPotTests
//
//  Created by Tassja Bretz on 02.10.25.
//

import XCTest
import SwiftData
@testable import savingPot



final class TransactionTests: XCTestCase {
    
    var sut: TransactionFunctions!
    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: Transaction.self, configurations: config)
        context = ModelContext(container)
        sut = TransactionFunctions()
    }

    override func tearDown() {
        sut = nil
        container = nil
        context = nil
        super.tearDown()
    }
    func testAddTransaction_ShouldIncreaseCount_error() {
  
        let categoryName = "Sonstiges"
        let title = "Test Kauf"
        let amount = 19.99
        let type = Transaction.TransactionType.outcome
        
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", budget: 100.0, isOutgoing: true)
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
    
    func testAddTransaction_ShouldIncreaseCount() {
        
        let categoryName = "Drogerie"
        let title = "Test Kauf"
        let amount = 19.99
        let type = Transaction.TransactionType.outcome
        
  
        let testCategory = Category(categoryName: categoryName, iconName: "cart", budget: 100.0, isOutgoing: true)
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
            XCTAssertNil(error, "Es sollte kein Fehler auftreten")
           
        }


       
        
        let descriptor = FetchDescriptor<Transaction>()
        let results = try? context.fetch(descriptor)
        
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.titel, title)
        XCTAssertEqual(results?.first?.category?.categoryName, categoryName)
    }
    
    func testDeleteTransaction() {

        let transactionToDelete = Transaction(
            titel: "Miete",
            text: "Monatlich",
            amount: 800.0,
            type: .outcome
        )
        context.insert(transactionToDelete)
        try? context.save()
        
      
      

        
        sut.deleteTransaction(modelContext: context, transaction: transactionToDelete) { error in
            XCTAssertNil(error, "Es sollte kein Fehler beim Löschen auftreten")
        }

        let results = try? context.fetch(FetchDescriptor<Transaction>())
        XCTAssertEqual(results?.count, 0, "Die Transaktion sollte erfolgreich gelöscht worden sein.")
    }
    
    func testDeleteTransaction_fail() {

            let transactionToDeleteError = Transaction(
                titel: "Miete",
                text: "Monatlich",
                amount: 800.0,
                type: .outcome
            )
            context.insert(transactionToDeleteError)
            try? context.save()
            
            context.delete(transactionToDeleteError)
            try? context.save()
            
            
            let expectation = expectation(description: "Sollte einen Fehler im Callback liefern")

            
            sut.deleteTransaction(modelContext: context, transaction: transactionToDeleteError) { error in
                
                XCTAssertNotNil(error, "Es sollte ein Fehler auftreten, wenn die Transaktion nicht existiert.")
                
                
                expectation.fulfill()
            }
            waitForExpectations(timeout: 1.0)
        }
    
    func testFetchTransactions() {
        
        let transactionToDelete = Transaction(
            titel: "Miete",
            text: "Monatlich",
            amount: 800.0,
            type: .outcome
        )
        context.insert(transactionToDelete)
        try? context.save()
        
       let results =  sut.fetchTransactions(modelContext: context)
        
        XCTAssertEqual(results.count, 1)
        
    }
    
  
    
    func testAddTransaction_Validate_false() {
        let categoryName = ""
        let title = "Test Kauf"
        let amount = 0.0
        let description = "Description"
        
        let result = sut.validateTransaction(categoryName: categoryName, transactionTitel: title, description: description, amount: amount)
        
        XCTAssertFalse(Bool(result))
      
    }
    
    func testAddTransaction_Validate_true() {
        let categoryName = "Test"
        let title = "Test Kauf"
        let amount = 4.0
        let description = "Description"
        
        let result = sut.validateTransaction(categoryName: categoryName, transactionTitel: title, description: description, amount: amount)
        
        XCTAssertTrue(Bool(result))
      
    }
    
    func testEditTransaction_ShouldUpdateValues() {

        let category = Category(categoryName: "Essen", iconName: "fork.knife", budget: 100.0, isOutgoing: true)
        let newCategory = Category(categoryName: "Freizeit", iconName: "star", budget: 50.0, isOutgoing: true)
        context.insert(category)
        context.insert(newCategory)
        
        let transaction = Transaction(titel: "Döner", text: "Mittagessen", amount: 7.50, type: .outcome, category: category)
        context.insert(transaction)
        try? context.save()

   
        let newTitle = "Kino"
        let newAmount = 15.0
        let newType = Transaction.TransactionType.outcome

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
     
        }


        XCTAssertEqual(transaction.titel, newTitle)
        XCTAssertEqual(transaction.amount, newAmount)
        XCTAssertEqual(transaction.category?.categoryName, "Freizeit")
        
    }
}
