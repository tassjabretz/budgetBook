//
//  Category.swift
//  savingPot
//
//  Created by Tassja Bretz on 14.10.25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Transaction: Identifiable {
    

    var titel: String
    var text: String
    var amount: Double
    var transactionType: String
    var category: Category?
    var budgetBook: BudgetBook?
    
    init(titel: String, text: String, amount: Double, transactionType: String, category: Category? = nil, budgetBook: BudgetBook? = nil) {
        self.titel = titel
        self.text = text
        self.amount = amount
        self.transactionType = transactionType
        self.category = category
        self.budgetBook = budgetBook
    }
    
    
    
    
   
    
    
}
