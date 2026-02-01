import SwiftUI
import SwiftData

struct AddTransactionView: View {
    
    
    @State var title = ""
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
    @State private var selectedType: Transaction.TransactionType = .expense
    @State private var selectedCategory = ""

    
    var body: some View {
        
      
        
        VStack(spacing: 0) {
            bodyContent()
            
            Spacer()
            
            actionBar()
        }
        .padding()
        .font(.caption)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.adaptiveWhiteBackground)
        .toolbar { toolbarPrincipal }
        .sheet(isPresented: $showResultView) { resultSheet }
        .onChange(of: showResultView) { _, newValue in
            if newValue == false { dismiss() }
        }
        .task { await initialLoadTask() }
        .toast(isShowing: $showToast, message: message ?? "Unbekannter Status")
        .overlay(loadingIndicators)
    }
    
    private func bodyContent() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                InputGroupView(title: $title, text: $text, amount: $amount, isError: $isError, selectedType: $selectedType)
                                    
                                    
                InputGroupSelectionView(
                    categories: categories, selectedType: $selectedType,
                    selectedCategory: $selectedCategory,
                                   )
            }
        }
        .onChange(of: selectedType) { _, newValue in
            updateCategories(for: newValue)
        }
    }
    
    private func updateCategories(for type: Transaction.TransactionType) {
        let newCategories: [Category]
        if type == .income {
            newCategories = CategoryFunctions.fetchCategoriesIncome(modelContext: modelContext)
            selectedCategory = "salary"
        } else {
            newCategories = CategoryFunctions.fetchCategoriesOutcome(modelContext: modelContext)
            selectedCategory = "rent"
        }
        self.categories = newCategories
    }
    
    private func actionBar() -> some View {
            Button(action: saveTransaction) {
                Text("add_transaction")
                    .modifier(ButtonNormal(buttonTitel: ""))
            }
        }
    
    @ToolbarContentBuilder
    private var toolbarPrincipal: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("add_transaction")
                .foregroundColor(.adaptiveBlack)
                .font(.system(.headline))
                .fontWeight(.bold)
        }
    }
    
    private var resultSheet: some View {
        ResultView(
            message: self.message ?? "Hinweis: Keine Nachricht vorhanden",
            text: self.messageTitle ?? "Hinweis",
            selectedTab: $selectedTab
        )
    }
    
    private var loadingIndicators: some View {
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
    
    private func initialLoadTask() async {
        do {
            let initialCheckCategory = try modelContext.fetch(FetchDescriptor<Category>())
            if initialCheckCategory.isEmpty {
                CategoryFunctions.applyCategories(modelContext: modelContext)
            }
            if selectedType == .expense {
                categories = CategoryFunctions.fetchCategoriesOutcome(modelContext: modelContext)
                selectedCategory = "rent"
            } else {
                categories = CategoryFunctions.fetchCategoriesIncome(modelContext: modelContext)
                selectedCategory = "salary"
            }
        } catch {
            print("Initial data check failed: \(error)")
        }
    }
    
    func saveTransaction()  {
        
        
        
        let isValid = TransactionFunctions.validateTransaction(
            categoryName: selectedCategory,
            transactionTitel: title,
            description: text,
            amount: amount ?? 0.0
        )
        
        if isValid {
            Task {
                do {
                    try await TransactionFunctions.addTransaction(
                        modelContext: modelContext,
                        categoryName: selectedCategory,
                        transactionTitel: title,
                        description: text,
                        amount: amount ?? 0.0,
                        transactionType: selectedType
                    )
                    message =  NSLocalizedString("transaction_add_success", comment: "success message")
                    withAnimation {
                        showToast = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation {
                            selectedTab = 0
                            showToast = false
                            dismiss()
                        }
                    }
                    showResultView = false
            
                } catch {
                    message = error.localizedDescription +
                              NSLocalizedString("transaction_add_error", comment: "error message") +
                              (selectedCategory)
                    messageTitle = NSLocalizedString("error_title", comment: "error Title")
                    showToast = false
                    showResultView = true
                }
            }
        }
        else {
            self.isError = true
        }
        
    }
    
    
    
    
    struct InputGroupView: View {
        
          @Binding var title: String
          @Binding var text: String
          @Binding var amount: Double?
          @Binding var isError: Bool
          @Binding var selectedType: Transaction.TransactionType
          @State private var amountString: String = "0.00"
        
        let placeholderText = NSLocalizedString("description", comment: "test")
        @FocusState private var focusedField: Field?
        
        
        enum Field: Hashable {
            case title, description, amount
        }
        
        var body: some View {
 
            Group {
                
                TextField("transaction_title_placeholder", text: $title, prompt: Text("transaction_title_placeholder").foregroundStyle(Color.adaptiveBlack))
                                  .focused($focusedField, equals: .title)
                                  .modifier(TextFieldModifier(isError: isError && title.isEmpty))
                
                if isError && title.isEmpty {
                    errorLabel("empty_title")
                }
                
                
                TextField(placeholderText, text: $text, prompt: Text(placeholderText).foregroundStyle(Color.adaptiveBlack))
                    .focused($focusedField, equals: .description)
                    .modifier(TextFieldModifierBig(isError: isError && text.isEmpty))
                
                if isError && text.isEmpty {
                    errorLabel("empty_description")
                }
                
                HStack(spacing: 4) {
                    TextField("0,00", value: $amount, format: .number.precision(.fractionLength(2)), prompt: Text("0,00").foregroundStyle(.adaptiveBlack))
                        .focused($focusedField, equals: .amount)
                        .keyboardType(.decimalPad)
                        .fixedSize(horizontal: true, vertical: false)
                    Text("€")
                        .foregroundStyle(Color.adaptiveBlack)
                    
                    Spacer()
                }
                
                .modifier(TextFieldModifier(isError: isError && amount == 0))
                
                
                if isError && amount == 0  {
                    errorLabel("empty_amount")
                }
                
                
                HStack {
                    Text(selectedType.localizedName)
                    Spacer()
                }
                .modifier(TextFieldModifier(isError: false))
            }
            
            .onChange(of: focusedField) { oldValue, newValue in
                if newValue != nil {
                    withAnimation {
                        isError = false
                    }
                }
            }
            .onChange(of: title) { isError = false }
            .onChange(of: text) { isError = false }
            
        }
        
        private func errorLabel(_ key: String) -> some View {
            Label(NSLocalizedString(key, comment: ""), systemImage: "exclamationmark.circle")
                .font(.caption)
                .foregroundStyle(.red)
        }
    }
    
    
    
    
    struct InputGroupSelectionView: View {
        
        var categories: [Category]
        @Binding var selectedType: Transaction.TransactionType
        @Binding var selectedCategory: String
        
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
                                withAnimation {
                                    selectedType = type
                                }
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
                            Text(selectedCategory.isEmpty ? "Select" : NSLocalizedString(selectedCategory, comment: ""))
                        
                            
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
    
    @Previewable @State var selectedTab = 0
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Transaction.self, Category.self, configurations: config)
    
    
    
    let categories = [
        Category(categoryName: "Essen", iconName: "cart", defaultBudget: 300.0, isOutgoing: true),
        Category(categoryName: "Freizeit", iconName: "star", defaultBudget: 100.0, isOutgoing: true),
        Category(categoryName: "Gehalt", iconName: "eurosign", defaultBudget: 2500.0, isOutgoing: false)
    ]
    
    categories.forEach { container.mainContext.insert($0) }
    
    return  NavigationStack {
         AddTransactionView(selectedTab: $selectedTab)
            .modelContainer(container)
    }
}

