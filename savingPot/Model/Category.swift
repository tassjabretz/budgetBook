//
//  Category.swift
//  savingPot
//
//  Created by Tassja Bretz on 14.10.25.
//

import Foundation
import SwiftData


@Model
final class Category: Identifiable {
 
    var categoryName: String
    var iconName: String
    var budget: Double
    var isOutgoing: Bool
    
    @Relationship(inverse: \Transaction.category)
        var transactions: [Transaction]?
    
    init( categoryName: String, iconName: String, budget: Double, isOutgoing: Bool, transactions: [Transaction]? = nil) {
        self.categoryName = categoryName
        self.iconName = iconName
        self.budget = budget
        self.isOutgoing = isOutgoing
        self.transactions = transactions
    }
    
    
   
    
    
}
