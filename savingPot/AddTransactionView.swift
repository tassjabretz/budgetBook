import SwiftUI
import SwiftData


struct AddTransactionView: View {
    
    
    @State var titel = ""
    @State var text = ""
    @State var amount: Double = 0.0
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
        
        VStack(alignment: .leading) {
            
            
            InputGroupView(titel: $titel, text: $text, amount: $amount, isError: $isError, selectedType: $selectedType)
            
            
            InputGroupSelectionView(
                selectedType: $selectedType,
                selectedCategory: $selectedCategory,
                categories: categories,
            )
            
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
                    selectedCategory = "Miete"
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
            
        }
        .task {
            do {
                let initialCheckCategory = try modelContext.fetch(FetchDescriptor<Category>())
                if initialCheckCategory.isEmpty {
                    CategoryFunctions().applyCategories(modelContext: modelContext)
                }
                
                
                if selectedType == .outcome {
                    categories = CategoryFunctions().fetchCategoriesOutcome(modelContext: modelContext)
                    selectedCategory = "Miete"
                } else {
                    categories = CategoryFunctions().fetchCategoriesIncome(modelContext: modelContext)
                    selectedCategory = "salary"
                }
            } catch {
                print("Initial data check failed: \(error)")
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
                    .foregroundColor(.black)
                    .font(.system(.title))
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
            amount: amount
        )
        
        if isValid {
            TransactionFunctions().addTransaction(
                modelContext: modelContext,
                categoryName: selectedCategory,
                transactionTitel: titel,
                description: text,
                amount: amount,
                transactionType: selectedType
            )
            { error in
                
                if let error = error {
                    message =  error.localizedDescription + NSLocalizedString("transaction_add_error", comment: "error message")
                    messageTitle = NSLocalizedString("error_title", comment: "error Title")
                    showToast = false
                    showResultView = true
                    
                } else {
                    
                    message =  NSLocalizedString("transaction_add_success", comment: "success message")
                    withAnimation {
                        showToast = true
                    }
                    
                    showResultView = false
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
        @Binding var amount: Double
        @Binding var isError: Bool
        @Binding var selectedType: Transaction.TransactionType
        let placeholderText = NSLocalizedString("description", comment: "test")
        
        
        var body: some View {
            Group {
                TextField(
                    "transaction_title_placeholder",
                    text: $titel,
                    prompt: Text("transaction_title_placeholder")
                        .foregroundColor(.black)
                )
                .modifier(TextFieldModifier(isError: isError))
                
                
                if(isError && titel.isEmpty)
                {
                    Label(NSLocalizedString("empty_title", comment: "no title"), systemImage: "exclamationmark.circle")
                }
                
                TextField(
                    placeholderText,
                    text: $text,
                    prompt: Text(placeholderText)
                        .foregroundColor(.black)
                )
                .modifier(TextFieldModifierBig(isError: isError))
                if(isError && text.isEmpty)
                {
                    Label(NSLocalizedString("empty_description", comment: "no description"), systemImage: "exclamationmark.circle")
                }
                
                
                TextField("amount", value: $amount, formatter: NumberFormatter())
                    .modifier(TextFieldModifier(isError: isError))
                if(isError && amount == 0)
                {
                    Label(NSLocalizedString("empty_amount", comment: "No Amount"), systemImage: "exclamationmark.circle")
                }
                
                HStack {
                    Text(selectedType.localizedName)
                    Spacer()
                }
                .padding()
                .background(.adaptiveWhiteCard)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                
                
            }
            
            .onChange(of: [titel, text]) {
                if isError {
                    isError = false
                }
            }
            .onChange(of: amount) {
                if isError {
                    isError = false
                }
            }
            
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
                                Text(cat.categoryName).tag(cat.categoryName)
                            }
                        }
                    } label: {
                        
                        HStack {
                            if !selectedCategory.isEmpty {
                                Text(selectedCategory)
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
            .frame(height: 100)
            .background(.adaptiveWhiteCard)
            
            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 2)
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
