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
    
    var id = UUID()
    var title: String
    
   
    
    init(titel: String) {
        self.title = titel
    }
    
    
    
    
   
    
    
}
