import Foundation
import SwiftData


@Model 
final class Transaction: Identifiable {
    var title: String
    var text: String
    var amount: Double
    var type: TransactionType
    var category: Category?
    var date: Date
    
    init(title: String, text: String, amount: Double, type: TransactionType, category: Category? = nil, date: Date = Date()) {
        self.title = title
        self.text = text
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
    }
    
    enum TransactionType: String, Codable, CaseIterable, Identifiable {
        case income = "Einnahme"
        case expense = "Ausgabe"
        
        var id: String { self.rawValue }
        
        var localizedName: String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
