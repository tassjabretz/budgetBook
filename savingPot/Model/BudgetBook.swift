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
    var transaction: Transaction?
    
    init(titel: String) {
        self.titel = titel
    }
    
    
    
    
   
    
    
}
