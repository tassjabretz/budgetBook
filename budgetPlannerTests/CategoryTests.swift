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
final class CategoryTests: XCTestCase {
    
    var sut: CategoryFunctions!
    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: Category.self, configurations: config)
        context = ModelContext(container)
        sut = CategoryFunctions.shared
    }

    override func tearDown() {
        sut = nil
        container = nil
        context = nil
        super.tearDown()
    }
    
    
    func testGetAllCategories() async throws {
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        let testCategory2 = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 100.0, isOutgoing: false)
        let testCategory3 = Category(categoryName: "Miete", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        context.insert(testCategory2)
        context.insert(testCategory3)
        try context.save()

        
        let categories = sut.fetchCategories(modelContext: context)
        
        
        XCTAssertEqual(categories.count, 3)
    

    }
    
    func testGetIncomeCategories() async throws {
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        let testCategory2 = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 100.0, isOutgoing: false)
        let testCategory3 = Category(categoryName: "Miete", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        context.insert(testCategory2)
        context.insert(testCategory3)
        try context.save()

        let categories = sut.fetchCategoriesIncome(modelContext: context)
        
        XCTAssertEqual(categories.count, 1)
        
     
    }
    
    func testGetOutcomeCategories() async throws {
  

        
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        let testCategory2 = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 100.0, isOutgoing: false)
        let testCategory3 = Category(categoryName: "Miete", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        context.insert(testCategory2)
        context.insert(testCategory3)
        try context.save()

        let categories = sut.fetchCategoriesOutcome(modelContext: context)
        
        XCTAssertEqual(categories.count, 2)
        
  
    }
    
    func testEditBudget() async throws {
        
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        try context.save()
        
        testCategory.defaultBudget = 20.00
        
        try await sut.saveAllCategories(modelContext: context)
     
        
        XCTAssertEqual(testCategory.defaultBudget, 20.00)
        
        
    }
    
    
    func testNewBudgetAfterAddTransactionOutcome() async throws{
        
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        let transaction = Transaction(
            title: "Make up",
            text: "Rosmann",
            amount: 30,
            type: .expense
        )
        context.insert(transaction)
        context.insert(testCategory)
        try context.save()
        

       sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        
        XCTAssertEqual(testCategory.currentBudget, 70.00)
        
      
    }
    
    func testNewBudgetAfterAddTransactionIncome() throws {
        
  
        let testCategory = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 20, isOutgoing: false)
        
        let transaction = Transaction(
            title: "gehalt",
            text: "testfirma",
            amount: 3000.00,
            type: .income
        )
        context.insert(transaction)
        context.insert(testCategory)
        try context.save()
        

        sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        
        XCTAssertEqual(testCategory.currentBudget, 3020.00)
       
    }
    
    func testNewBudgetAfterAddTransactionNegative()  throws {
        
  
        let testCategory = Category(categoryName: "Internet", iconName: "cart", defaultBudget: 30, isOutgoing: true)
        
        let transaction = Transaction(
            title: "negativ",
            text: "testnegativ",
            amount: 50,
            type: .expense
        )
        context.insert(transaction)
        context.insert(testCategory)
        try context.save()
        

        sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        
        XCTAssertEqual(testCategory.currentBudget, -20.00)
        
        
    }

    
    func testAddBudgetAfterChangeTransaction()  throws {

        let defaultBudget = 100.0
        let testCategory = Category(
            categoryName: "Drogerie",
            iconName: "cart",
            defaultBudget: defaultBudget,
            isOutgoing: true
        )
        testCategory.currentBudget = 100.0
        
        let transaction = Transaction(
            title: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .expense
        )
        
        
        
        context.insert(transaction)
        context.insert(testCategory)
        
        sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        

        sut.setNewBudgetAfterEditTransaction(
            modelContext: context,
            oldCategory: testCategory,
            transaction: transaction,
            newCategory: testCategory,
            newAmount: 20,
            newType: transaction.type
        )
        
 
        XCTAssertEqual(testCategory.currentBudget, 80.0, "Budget wurde erhöht")
      
    }
    
    
    
    func testAddBudgetAfterChangeCategory()  throws {

        let defaultBudget = 100.0
        let testCategory = Category(
            categoryName: "Drogerie",
            iconName: "cart",
            defaultBudget: defaultBudget,
            isOutgoing: true
        )
        testCategory.currentBudget = 100.0
        
        let testCategory2 = Category(
            categoryName: "Telefon",
            iconName: "cart",
            defaultBudget: defaultBudget,
            isOutgoing: true
        )
        
        testCategory2.currentBudget = 70.0
        
        let transaction = Transaction(
            title: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .expense
        )
        
        
        
        context.insert(transaction)
        context.insert(testCategory)
        
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        

         sut.setNewBudgetAfterEditTransaction(
            modelContext: context,
            oldCategory: testCategory,
            transaction: transaction,
            newCategory: testCategory2,
            newAmount: 20,
            newType: transaction.type
        )
        
 
        XCTAssertEqual(testCategory.currentBudget, 100.0, "Budget wurde erhöht")
        XCTAssertEqual(testCategory2.currentBudget, 50.0, "Budget wurde erhöht")
    }
    
    func testReduceBudgetAfterChangeTransaction() throws {

        let defaultBudget = 100.0
        let testCategory = Category(
            categoryName: "Drogerie",
            iconName: "cart",
            defaultBudget: defaultBudget,
            isOutgoing: true
        )
        testCategory.currentBudget = 100.0
        
        let transaction = Transaction(
            title: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .expense
        )
        
        
        
        context.insert(transaction)
        context.insert(testCategory)
        
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        

         sut.setNewBudgetAfterEditTransaction(
            modelContext: context,
            oldCategory: testCategory,
            transaction: transaction,
            newCategory: testCategory,
            newAmount: 80,
            newType: transaction.type
        )
        
 
        XCTAssertEqual(testCategory.currentBudget, 20.0, "Budget wurde reduziert")
    }
    
    func testReduceBudgetAfterChangeTransactionNegative() throws {

        let defaultBudget = 100.0
        let testCategory = Category(
            categoryName: "Drogerie",
            iconName: "cart",
            defaultBudget: defaultBudget,
            isOutgoing: true
        )
        testCategory.currentBudget = 100.0
        
        let transaction = Transaction(
            title: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .expense
        )
        
        
        
        context.insert(transaction)
        context.insert(testCategory)
        
        sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        

        sut.setNewBudgetAfterEditTransaction(
            modelContext: context,
            oldCategory: testCategory,
            transaction: transaction,
            newCategory: testCategory,
            newAmount: 110,
            newType: transaction.type
        )
        
 
        XCTAssertEqual(testCategory.currentBudget, -10, "Budget wurde reduziert")
    }

    func testReduceIncomeBudgetAfterDeleteTransactionIncome()  {

        let defaultBudget = 0.0
        let testCategory = Category(
            categoryName: "Gehalt",
            iconName: "cart",
            defaultBudget: defaultBudget,
            isOutgoing: false
        )
       
        
        let transaction = Transaction(
            title: "Gehalt",
            text: "Testfirma",
            amount: 2000.00,
            type: .income
        )
        let transaction2 = Transaction(
            title: "Gehalt",
            text: "Testfirma",
            amount: 2000.00,
            type: .income
        )
        
        
        context.insert(transaction)
        context.insert(transaction2)
        context.insert(testCategory)
        
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction2)
        

         sut.undoBudgetImpactBeforeDeletion(modelContext: context, category: testCategory, transaction: transaction)
        
        XCTAssertEqual(testCategory.currentBudget, 2000.00, "Budget wurde reduziert")
    }
    
    func testReduceIncomeBudgetAfterDeleteTransactionOutcome()  {


        let testCategory = Category(
            categoryName: "sonstige Ausgaben",
            iconName: "cart",
            defaultBudget: 1000.00,
            isOutgoing: true
        )
       
        
        let transaction = Transaction(
            title: "internet",
            text: "kosten",
            amount: 50.00,
            type: .expense
        )
        let transaction2 = Transaction(
            title: "Gehalt",
            text: "Testfirma",
            amount: 30.00,
            type: .expense
        )
        
        
        context.insert(transaction)
        context.insert(transaction2)
        context.insert(testCategory)
        
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction2)
        

         sut.undoBudgetImpactBeforeDeletion(modelContext: context, category: testCategory, transaction: transaction2)
        
        XCTAssertEqual(testCategory.currentBudget, 950.00, "Budget wurde reduziert")
    }
    

    func testResetBudgetEveryMonth() async throws {
       
        let initialDefault = 50.0
        let testCategory = Category(
            categoryName: "sonstige Ausgaben",
            iconName: "cart",
            defaultBudget: initialDefault,
            isOutgoing: true
        )
        
        context.insert(testCategory)
        
    
        testCategory.currentBudget = 10.0
     
        var components = DateComponents()
            components.year = 2026
            components.month = 2
            components.day = 1
            let futureDate = Calendar.current.date(from: components)!

            UserDefaults.standard.removeObject(forKey: "lastBudgetResetDate")
        
        sut.checkAndResetMonthlyBudget(modelContext: context, currentDate: futureDate)

        XCTAssertEqual(testCategory.currentBudget, initialDefault, "Das Budget sollte auf den Standardwert zurückgesetzt worden sein.")
    }
    
    func testNotResetBudgetEveryMonth() async throws {

        let initialDefault = 50.0
        let testCategory = Category(
            categoryName: "sonstige Ausgaben",
            iconName: "cart",
            defaultBudget: initialDefault,
            isOutgoing: true
        )
        context.insert(testCategory)
        testCategory.currentBudget = 10.0
        
        
        var components = DateComponents()
        components.year = 2026
        components.month = 2
        components.day = 15
        let futureDate = Calendar.current.date(from: components)!
        
     
        let currentIdentifier = "2-2026"
        UserDefaults.standard.set(currentIdentifier, forKey: "lastBudgetResetDate")

 
        sut.checkAndResetMonthlyBudget(modelContext: context, currentDate: futureDate)

        XCTAssertEqual(testCategory.currentBudget, 10.0, "Das Budget darf nicht resettet werden, wenn der Monat bereits als erledigt markiert ist.")
    }

    
    
    
}
