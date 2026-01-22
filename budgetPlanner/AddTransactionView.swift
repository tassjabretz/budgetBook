import SwiftUI
import SwiftData


struct AddTransactionView: View {
    
    
    @State var titel = ""
    @State var text = ""
    @State var amount: Double?
    @State var isError = false
    @State var showToast = false
    @State private var description: String = ""
    @State private var message: String?
    @State private var messageTitle: String?
    @State private var showResultView = false
    @Binding var selectedTab: Int
    let placeholderText = NSLocalizedString("description", comment: "test")
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var categories: [Category] = []
    @State private var selectedType: Transaction.TransactionType = .outcome
    @State private var selectedCategory = ""
    
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    Color.adaptiveWhiteBackground.ignoresSafeArea()
                    
                    InputGroupView(titel: $titel, text: $text, amount: $amount, isError: $isError, selectedType: $selectedType)
                    
                    
                    InputGroupSelectionView(
                        selectedType: $selectedType,
                        selectedCategory: $selectedCategory,
                        categories: categories,
                    )
                    
                }
            }
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: saveTransaction) {
                        Text("add_transaction")
                            .modifier(ButtonNormal(buttonTitel: ""))
                    }
                    Spacer()
                    
                }
                
            
            
            .onChange(of: selectedType) { _, newValue in
                let newCategories: [Category]
                
                
                if newValue == .income {
                    newCategories = CategoryFunctions().fetchCategoriesIncome(modelContext: modelContext)
                    selectedCategory = "salary"
                } else {
                    newCategories = CategoryFunctions().fetchCategoriesOutcome(modelContext: modelContext)
                    selectedCategory = "rent"
                }
                categories = newCategories
            }
            
            
            .onChange(of: description) { oldValue, newValue in
                description = newValue
            }
            
            
            .onChange(of: categories) { oldValue, newValue in
                if let firstCategoryName = newValue.first?.categoryName {
                    if selectedCategory == "" {
                        selectedCategory = firstCategoryName
                    }
                }
            }
            
        
        .task {
            do {
                let initialCheckCategory = try modelContext.fetch(FetchDescriptor<Category>())
                if initialCheckCategory.isEmpty {
                    CategoryFunctions().applyCategories(modelContext: modelContext)
                }
                
                
                if selectedType == .outcome {
                    categories = CategoryFunctions().fetchCategoriesOutcome(modelContext: modelContext)
                   selectedCategory = "rent"
                } else {
                    categories = CategoryFunctions().fetchCategoriesIncome(modelContext: modelContext)
                    selectedCategory = "salary"
                }
            } catch {
                print("Initial data check failed: \(error)")
            }
        }
        }
        .toast(isShowing: $showToast, message: message ?? "Unbekannter Status")
        .overlay(loadingIndicators)
        .padding()
        .font(.caption)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.adaptiveWhiteBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("add_transaction")
                    .foregroundColor(.adaptiveBlack)
                    .font(.system(.headline))
                    .fontWeight(.bold)
            }
        }
        .toolbarBackground(
            Color.adaptiveGray,
            for: .navigationBar, .tabBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        .sheet(isPresented: $showResultView) {
            
            ResultView(
                message: self.message ?? "Hinweis: Keine Nachricht vorhanden",
                text: self.messageTitle ?? "Hinweis", selectedTab: $selectedTab)
        }
        .onChange(of: showResultView) { oldValue, newValue in
            if newValue == false {
                dismiss()
            }
        }
        
    }
    
    
    
    var loadingIndicators: some View {
        VStack {
            if categories.isEmpty {
                ProgressView("loading_categories")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .controlSize(.large)
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    )
            }
        }
    }
    
    func saveTransaction()  {
        
        let isValid = TransactionFunctions().validateTransaction(
            categoryName: selectedCategory,
            transactionTitel: titel,
            description: text,
            amount: amount ?? 0.0
        )
        
        if isValid {
            TransactionFunctions().addTransaction(
                modelContext: modelContext,
                categoryName: selectedCategory,
                transactionTitel: titel,
                description: text,
                amount: amount ?? 0.00,
                transactionType: selectedType
            )
            { error in
                
                if let error = error {
                    message =  error.localizedDescription + NSLocalizedString("transaction_add_error", comment: "error message") + selectedCategory
                    messageTitle = NSLocalizedString("error_title", comment: "error Title")
                    showToast = false
                    showResultView = true
                    
                } else {
                    
                    message =  NSLocalizedString("transaction_add_success", comment: "success message")
                    withAnimation {
                        showToast = true
                       
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation {
                            
                            selectedTab = 0
                            
                            
                            showToast = false
                        }
                    }
                    
                    showResultView = false
                    
                   
                    titel = ""
                    text = ""
                    amount = 0
                   
                }
                
            }
        }
        else {
            self.isError = true
        }
        
        
        
    }
    
    
    
    struct InputGroupView: View {
        @Binding var titel: String
        @Binding var text: String
        @Binding var amount: Double?
        @Binding var isError: Bool
        @Binding var selectedType: Transaction.TransactionType
        @State private var amountString: String = "0.00"
        
        let placeholderText = NSLocalizedString("description", comment: "test")
        @FocusState private var focusedField: Field?
        
        // WICHTIG: Hashable für @FocusState
        enum Field: Hashable {
            case title, description, amount
        }
        
        var body: some View {
            Group {
                // TITEL
                TextField("transaction_title_placeholder", text: $titel, prompt: Text("transaction_title_placeholder").foregroundStyle(Color.adaptiveBlack))
                    .focused($focusedField, equals: .title)
                    .modifier(TextFieldModifier(isError: isError && titel.isEmpty))
                
                if isError && titel.isEmpty {
                    errorLabel("empty_title")
                }
                
                // BESCHREIBUNG
                TextField(placeholderText, text: $text, prompt: Text(placeholderText).foregroundStyle(Color.adaptiveBlack))
                    .focused($focusedField, equals: .description)
                    .modifier(TextFieldModifierBig(isError: isError && text.isEmpty))
                
                if isError && text.isEmpty {
                    errorLabel("empty_description")
                }
                
                TextField("0,00", value: $amount, format: .currency(code: "EUR"),  prompt: Text("0,00 €").foregroundStyle(Color.adaptiveBlack))
                    .focused($focusedField, equals: .amount)
                    .keyboardType(.decimalPad)
                    .modifier(TextFieldModifier(isError: isError && amount == nil))
              
                
                if isError && amount == nil  {
                    errorLabel("empty_amount")
                }
                
                
                HStack {
                    Text(selectedType.localizedName)
                    Spacer()
                }
                .modifier(TextFieldModifier(isError: false))
            }
         
            .onChange(of: focusedField) { oldValue, newValue in
                // Wenn newValue nicht nil ist, bedeutet das, ein Feld wurde ausgewählt
                if newValue != nil {
                    withAnimation {
                        isError = false
                    }
                }
            }
            .onChange(of: titel) { isError = false }
            .onChange(of: text) { isError = false }
            
            .onChange(of: amountString) { oldValue, newValue in
                // 1. Filtern (nur Zahlen und Komma)
                let filtered = newValue.filter { "0123456789,.".contains($0) }
                if filtered != newValue {
                    amountString = filtered
                }
                
                // 2. Umwandlung in Double
                let normalized = filtered.replacingOccurrences(of: ",", with: ".")
                if let doc = Double(normalized) {
                    amount = doc
                    // WICHTIG: Hier sofort den Fehler löschen, wenn die Zahl gültig ist!
                    withAnimation {
                        isError = false
                    }
                } else {
                    amount = nil
                }
            }        }
        
        private func errorLabel(_ key: String) -> some View {
            Label(NSLocalizedString(key, comment: ""), systemImage: "exclamationmark.circle")
                .font(.caption)
                .foregroundStyle(.red)
        }
    }
    
    
    
    
    struct InputGroupSelectionView: View {
        
        
        
        @Binding var selectedType: Transaction.TransactionType
        @Binding var selectedCategory: String
        var categories: [Category]
        
        var body: some View {
            VStack {
                
                HStack  {
                    ForEach(Transaction.TransactionType.allCases) { type in
                        Text(type.localizedName).tag(type)
                            .font(.caption)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 20)
                            .background(
                                selectedType == type
                                ? Color.secondary.opacity(0.15)
                                : Color.clear
                            )
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedType = type
                            }
                    }
                    
                    .padding(.top, 16)
                    Spacer()
                    
                }
                .frame(height: 50)
                
                Divider()
                
                HStack {
                    Text("select_category")
                        .font(.caption)
                        .bold()
                    
                    Spacer()
                    
                    Menu {
                        Picker("", selection: $selectedCategory) {
                            ForEach(categories, id: \.categoryName) { cat in
                                Text(NSLocalizedString(cat.categoryName, comment: "Catgeory")).tag(cat.categoryName)
                            }
                        }
                    } label: {
                        
                        HStack {
                            if !selectedCategory.isEmpty {
                                Text(NSLocalizedString(selectedCategory, comment: "category"))
                                    .font(.caption)
                                    .foregroundColor(.adaptiveBlack)
                            }
                            
                            Image(systemName: "arrow.down.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.secondary)
                                .frame(width: 25)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                
            }
            .padding(.horizontal)
            .frame(height: 100)
            .modifier(TextFieldModifierBig(isError: false))
            
           
        }
    }
}

    
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Transaction.self, Category.self, configurations: config)
    

    let categories = [
        Category(categoryName: "Essen", iconName: "cart", defaultBudget: 300.0, isOutgoing: true),
        Category(categoryName: "Freizeit", iconName: "star", defaultBudget: 100.0, isOutgoing: true),
        Category(categoryName: "Gehalt", iconName: "eurosign", defaultBudget: 2500.0, isOutgoing: false)
    ]
    
    categories.forEach { container.mainContext.insert($0) }
    
    return NavigationStack {
        AddTransactionView(selectedTab: .constant(0))
            .modelContainer(container)
    }
}
