//
//  savingPotTests.swift
//  savingPotTests
//
//  Created by Tassja Bretz on 02.10.25.
//

import XCTest
import SwiftData
@testable import savingPot



final class CategoryTests: XCTestCase {
    
    var sut: CategoryFunctions!
    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: Category.self, configurations: config)
        context = ModelContext(container)
        sut = CategoryFunctions()
    }

    override func tearDown() {
        sut = nil
        container = nil
        context = nil
        super.tearDown()
    }
    
    
    func testGetAllCategories() {
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        let testCategory2 = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 100.0, isOutgoing: false)
        let testCategory3 = Category(categoryName: "Miete", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        context.insert(testCategory2)
        context.insert(testCategory3)
        try? context.save()

        
        let categories = sut.fetchCategories(modelContext: context)
        
        
        XCTAssertEqual(categories.count, 3)
        
        context.delete(testCategory)
        context.delete(testCategory2)
        context.delete(testCategory3)
        
        try? context.save()

    }
    
    func testGetIncomeCategories() {
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        let testCategory2 = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 100.0, isOutgoing: false)
        let testCategory3 = Category(categoryName: "Miete", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        context.insert(testCategory2)
        context.insert(testCategory3)
        try? context.save()

        let categories = sut.fetchCategoriesIncome(modelContext: context)
        
        XCTAssertEqual(categories.count, 1)
        
        context.delete(testCategory)
        context.delete(testCategory2)
        context.delete(testCategory3)
        
        try? context.save()
    }
    
    func testGetOutcomeCategories() {
  

        
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        let testCategory2 = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 100.0, isOutgoing: false)
        let testCategory3 = Category(categoryName: "Miete", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        context.insert(testCategory2)
        context.insert(testCategory3)
        try? context.save()

        let categories = sut.fetchCategoriesOutcome(modelContext: context)
        
        XCTAssertEqual(categories.count, 2)
        
        context.delete(testCategory)
        context.delete(testCategory2)
        context.delete(testCategory3)
        
        try? context.save()
    }
    
    func testEditBudget() {
        
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        context.insert(testCategory)
        try? context.save()

        sut.editCategoryBudget(modelContext: context, category: testCategory, newBudget: 20.00)
        { error in
            XCTAssertNil(error, "Es sollte kein Fehler auftreten")
           
        }
        
        XCTAssertEqual(testCategory.currentBudget, 20.00)
        
        context.delete(testCategory)
        try? context.save()
    }
    
    
    func testNewBudgetAfterAddTransactionOutcome() {
        
  
        let testCategory = Category(categoryName: "Drogerie", iconName: "cart", defaultBudget: 100.0, isOutgoing: true)
        
        let transaction = Transaction(
            titel: "Make up",
            text: "Rosmann",
            amount: 30,
            type: .outcome
        )
        context.insert(transaction)
        context.insert(testCategory)
        try? context.save()
        

       sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        
        XCTAssertEqual(testCategory.currentBudget, 70.00)
        
        context.delete(testCategory)
        context.delete(transaction)
        try? context.save()
    }
    
    func testNewBudgetAfterAddTransactionIncome() throws {
        
  
        let testCategory = Category(categoryName: "Gehalt", iconName: "cart", defaultBudget: 20, isOutgoing: false)
        
        let transaction = Transaction(
            titel: "gehalt",
            text: "testfirma",
            amount: 3000.00,
            type: .income
        )
        context.insert(transaction)
        context.insert(testCategory)
        try context.save()
        

        sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        
        XCTAssertEqual(testCategory.currentBudget, 3020.00)
        
        context.delete(testCategory)
        context.delete(transaction)
        try? context.save()
    }
    
    func testNewBudgetAfterAddTransactionNegative() throws {
        
  
        let testCategory = Category(categoryName: "Internet", iconName: "cart", defaultBudget: 30, isOutgoing: true)
        
        let transaction = Transaction(
            titel: "negativ",
            text: "testnegativ",
            amount: 50,
            type: .outcome
        )
        context.insert(transaction)
        context.insert(testCategory)
        try context.save()
        

        sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
        
        XCTAssertEqual(testCategory.currentBudget, -20.00)
        
        context.delete(testCategory)
        context.delete(transaction)
        try? context.save()
    }

    
    func testAddBudgetAfterChangeTransaction() throws {

        let defaultBudget = 100.0
        let testCategory = Category(
            categoryName: "Drogerie",
            iconName: "cart",
            defaultBudget: defaultBudget,
            isOutgoing: true
        )
        testCategory.currentBudget = 100.0
        
        let transaction = Transaction(
            titel: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .outcome
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
    
    
    
    func testAddBudgetAfterChangeCategory() throws {

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
            titel: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .outcome
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
            titel: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .outcome
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
            titel: "Make up",
            text: "Rosmann",
            amount: 50,
            type: .outcome
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
            titel: "Gehalt",
            text: "Testfirma",
            amount: 2000.00,
            type: .income
        )
        let transaction2 = Transaction(
            titel: "Gehalt",
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
            titel: "internet",
            text: "kosten",
            amount: 50.00,
            type: .outcome
        )
        let transaction2 = Transaction(
            titel: "Gehalt",
            text: "Testfirma",
            amount: 30.00,
            type: .outcome
        )
        
        
        context.insert(transaction)
        context.insert(transaction2)
        context.insert(testCategory)
        
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction)
         sut.setNewBudgetAfterNewTransaction(modelContext: context, category: testCategory, transaction: transaction2)
        

         sut.undoBudgetImpactBeforeDeletion(modelContext: context, category: testCategory, transaction: transaction2)
        
        XCTAssertEqual(testCategory.currentBudget, 950.00, "Budget wurde reduziert")
    }


    
    
    
}
