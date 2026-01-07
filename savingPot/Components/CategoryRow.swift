import SwiftUI
import SwiftData

struct CategoryRow: View {
    
    @FocusState private var isFocused: Bool
    
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
        self._newBudget = State(initialValue: category.currentBudget)
        self.onSave = onSave
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: category.iconName)
                    .resizable()
                    .modifier(roundImage())
                
                Spacer()
                
                Text(NSLocalizedString(category.categoryName, comment: "category name"))
                    .font(.headline)
                    .frame(width: 120, alignment: .leading)
                    .foregroundColor(.black)
                
                Spacer()
                if isOutcome {
                        TextField("0.00 €", value: $newBudget, formatter: currencyFormatter)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .frame(maxWidth: 90)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                        
                    if isFocused && newBudget != category.currentBudget {
                        Button {
                            saveBudget()
                            isFocused = false
                        } label: {
                            Text("save")
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                    }
                else
                {
                    Text(String(category.currentBudget) + " €")
                        .font(.headline)
                        .frame(width: 120, alignment: .leading)
                        .foregroundColor(.black)
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
                category.currentBudget = newBudget
            }
        }
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
    
    VStack {
        if showToast {
            Text(message) // Simulierter Toast
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
        }
        
        CategoryRow(
            isOutcome: sampleCategory.isOutgoing,
            category: sampleCategory,
            selectedTab: .constant(0),
            onSave: { newMessage in
                message = newMessage
                withAnimation { showToast = true }
            }
        )
    }
    .modelContainer(for: Category.self, inMemory: true)
}
