import SwiftUI


struct CategoryRow: View {
    @FocusState private var isFocused: Bool
    let isOutcome: Bool
    
    @Bindable var category: Category
    @Binding var selectedTab: Int

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                roundImage(imageName: category.iconName)
                
                Spacer()
                
                Text(NSLocalizedString(category.categoryName, comment: "category name"))
                    .font(.caption)
                    .frame(width: 60, alignment: .leading)
                    .foregroundColor(.adaptiveBlack)
                
                Spacer()
                
                if isOutcome {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("current_budget")
                                .font(.caption.bold())
                                .foregroundColor(.secondary)
                            Text(category.currentBudget, format: .currency(code: "EUR"))
                                .font(.caption)
                        }
                        
                        HStack {
                            Text("default_budget")
                                .font(.caption.bold())
                            TextField("0.00 €", value: $category.defaultBudget, format: .currency(code: "EUR"))
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(maxWidth: 90)
                                .focused($isFocused)
                        }
                    }
                } else {
                    Text(category.currentBudget, format: .currency(code: "EUR"))
                        .font(.headline)
                        .foregroundColor(.adaptiveBlack)
                }
            }
        }
        .padding()
        .background(Color.adaptiveWhiteCard)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.adaptiveBlack.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    @Previewable @State var showToast = false
    @Previewable @State var message = ""
    
    let sampleCategory = Category(
        categoryName: "Essen",
        iconName: "cart.fill",
        defaultBudget: 100.0,
        isOutgoing: true
    )
    
    let sampleCategory2 = Category(
        categoryName: "Freizeit",
        iconName: "house.fill",
        defaultBudget: 50.0,
        isOutgoing: true
    )
    

  
        
        CategoryRow(
            isOutcome: sampleCategory.isOutgoing,
            category: sampleCategory,
            selectedTab: .constant(0),
        )
    
    CategoryRow(
        isOutcome: sampleCategory2.isOutgoing,
        category: sampleCategory2,
        selectedTab: .constant(0),
    )

    
}
