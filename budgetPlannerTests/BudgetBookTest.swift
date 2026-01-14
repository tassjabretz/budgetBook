//
//  savingPotTests.swift
//  savingPotTests
//
//  Created by Tassja Bretz on 02.10.25.
//

import XCTest
import SwiftData
@testable import budgetPlanner



final class BudgetBookTest: XCTestCase {
    
    var sut: BudgetBookFunctions!
    var container: ModelContainer!
    var context: ModelContext!

    override func setUp() {
        super.setUp()
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try! ModelContainer(for: BudgetBook.self, configurations: config)
        context = ModelContext(container)
        sut = BudgetBookFunctions()
    }

    override func tearDown() {
        sut = nil
        container = nil
        context = nil
        super.tearDown()
    }
    
    
    func testGetBudgetBooks() {
  

        
  
        let testBudgetBook = BudgetBook(titel: "TestBudgetBook")
        
        context.insert(testBudgetBook)
        try? context.save()
        
        
        let budgetBooks = sut.fetchBudgetBooks(modelContext: context)
        
        
        XCTAssertEqual(budgetBooks.count, 1)
        
      
        
        context.delete(testBudgetBook)
        
        try? context.save()

    }
    
    func testApplyBudgetBooks() {
  
        sut.applyBudgetBook(modelContext: context)
        
        let budgetBooks = sut.fetchBudgetBooks(modelContext: context)
        
        XCTAssertEqual(budgetBooks.count, 1)
       

    }
    
   
    
    
    
}
