import SwiftUI

struct CategoryRow: View {
    let isOutcome: Bool
    @Bindable var category: Category
    @Environment(\.modelContext) var modelContext
    
    @Binding var selectedTab: Int
    @State var newBudget: Double
    
    @State private var isError: Bool = false
    @State private var showToast: Bool = false
    @State private var message: String?
    
    var onSave: (String) -> Void
    
    init(isOutcome: Bool, category: Category, selectedTab: Binding<Int>, onSave: @escaping (String) -> Void) {
        self.isOutcome = isOutcome
        self.category = category
        self._selectedTab = selectedTab
        self._newBudget = State(initialValue: category.budget)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.iconName)
                    .resizable()
                    .modifier(roundImage())
                
                Spacer()
                
                Text(category.categoryName)
                    .font(.headline)
                    .frame(width: 120, alignment: .leading)
                    .foregroundColor(.adaptiveBlack)
                
                Spacer()
                if isOutcome {
                        TextField("0.00 €", value: $newBudget, formatter: currencyFormatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 90)
                            .multilineTextAlignment(.trailing)
                        
                        
                        if newBudget != category.budget {
                            Button {
                                saveBudget()
                               
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            } label: {
                                Text("save")
                                    .font(.caption)
                                    .foregroundColor(.adaptiveBlack)
                                    
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                }
                .animation(.spring(), value: newBudget)
            
            }
            
            Divider()
                .modifier(Line())
                .padding(.bottom, 4)
        }
      
      
    
    
    func saveBudget() {
        CategoryFunctions().editCategoryBudget(modelContext: modelContext, category: category, newBudget: newBudget) { error in
            if let error = error {
                onSave("Fehler: \(error.localizedDescription)")
            } else {
               
                onSave(NSLocalizedString("budget_updated_success", comment: "budget_updated_success"))
                category.budget = newBudget
            }
        }
    }
}

#Preview {
    let sampleCategory = Category(
        categoryName: "Essen",
        iconName: "cart.fill",
        budget: 100.0,
        isOutgoing: true
    )
}
