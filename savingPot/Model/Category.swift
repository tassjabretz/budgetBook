import SwiftData

@Model
final class Category: Identifiable {
    var categoryName: String
    var iconName: String
    var defaultBudget: Double
    var currentBudget: Double
    var isOutgoing: Bool
    
    @Relationship(inverse: \Transaction.category)
    var transactions: [Transaction] = []
    
    init(categoryName: String, iconName: String, defaultBudget: Double, isOutgoing: Bool) {
        self.categoryName = categoryName
        self.iconName = iconName
        self.defaultBudget = defaultBudget
        self.currentBudget = defaultBudget
        self.isOutgoing = isOutgoing
    }
}
