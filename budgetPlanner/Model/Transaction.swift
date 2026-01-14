import Foundation
import SwiftData
import SwiftUI

@Model
final class Transaction: Identifiable {
    var titel: String
    var text: String
    var amount: Double
    var type: TransactionType
    var category: Category?
    var date: Date
    
    init(titel: String, text: String, amount: Double, type: TransactionType, category: Category? = nil, date: Date = Date()) {
        self.titel = titel
        self.text = text
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
    }
    
    enum TransactionType: String, Codable, CaseIterable, Identifiable {
        case income = "Einnahme"
        case outcome = "Ausgabe"
        
        var id: String { self.rawValue }
        
        var localizedName: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
