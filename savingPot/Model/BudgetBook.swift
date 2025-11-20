//
//  Category.swift
//  savingPot
//
//  Created by Tassja Bretz on 14.10.25.
//

import Foundation
import SwiftData

@Model
final class BudgetBook: Identifiable {
    

    var titel: String
    
    @Relationship(inverse: \Transaction.budgetBook)
        var transactions: [Transaction]?
    
    init(titel: String, transactions: [Transaction]? = nil) {
        self.titel = titel
        self.transactions = transactions
    }
    
    
    
    
   
    
    
}
