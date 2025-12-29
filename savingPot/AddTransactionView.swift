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
            
            
            InputGroupView(titel: $titel, text: $text, amount: $amount, isError: $isError)
            
            
            InputGroupSelectionView(
                selectedType: $selectedType,
                selectedCategory: $selectedCategory,
                categories: categories,
            )
            
            Spacer()
            
            
            Button(action: saveTransaction) {
                Text("add_transaction")
                    .modifier(ButtonNormal(buttonTitel: ""))
                    .font(.title2)
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
                let initialBudgetBook = try modelContext.fetch(FetchDescriptor<BudgetBook>())
                
                if initialCheckCategory.isEmpty {
                    CategoryFunctions().applyCategories(modelContext: modelContext)
                }
                
                if initialBudgetBook.isEmpty {
                    BudgetBookFunctions().applyBudgetBook(modelContext: modelContext)
                }
            } catch {
                print("Initial data check failed: \(error)")
            }
            
            
            
            categories = CategoryFunctions().fetchCategories(modelContext: modelContext)
        }
        .toast(isShowing: $showToast, message: message ?? "Unbekannter Status")
        .overlay(loadingIndicators)
        .padding()
        .font(.caption)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.lightblue)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("add_transaction")
                    .foregroundColor(.adaptiveBlack)
                    .font(.system(.title))
                    .fontWeight(.bold)
            }
        }
        .toolbarBackground(
            Color.blueback,
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
            VStack(spacing: 0) {
                
                
                HStack {
                    Text("transaction_type")
                        .bold()
                        .font(.caption)
                        
                    Picker("transaction_type", selection: $selectedType) {
                        ForEach(Transaction.TransactionType.allCases) { type in
                                Text(type.localizedName).tag(type)
                                .font(.caption)
                            }
                        }
                    }
                .font(.caption)
                    .pickerStyle(.segmented)
                }
                .foregroundStyle(.adaptiveBlack)
                .padding(.top)
                
                
                VStack (alignment: .leading){
                    HStack {
                        Text("select_category")
                            .bold()
                            .font(.caption)
                        Spacer()
                        Picker("select_category", selection: $selectedCategory) {
                            ForEach(categories, id: \.self) { category in
                                
                                let localizedName = NSLocalizedString(category.categoryName, comment: "category")
                                Text(LocalizedStringKey(localizedName))
                                
                                    .tag(category.categoryName)
                                    .font(.caption)
                                   
                            }
                        }
                    }
                }
                .foregroundStyle(.adaptiveBlack)
                
                
            
            .scrollContentBackground(.hidden)
            .tint(Color(.adaptiveBlack))
            
        }
    }
}
    
#Preview {
    AddTransactionView(selectedTab:.constant(0))
}
