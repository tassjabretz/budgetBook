import SwiftUI
import SwiftData




struct EditTransactionView: View {
    @Binding var selectedTab: Int
    let transaction: Transaction
    

    @State var categories: [Category] = []
    
    @State private var showToast = false
    @State private var message: String?
    @State private var messageTitle: String?
    @State private var showResultView = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    
    enum Field: Hashable {
        case title, description, amount
    }
    
    @State private var isEditing: Bool = false
    @FocusState private var focusedField: Field?
    

    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 25) {
                formFields
                pickerFields
                actionButtons
            }
            .padding(.top)
        }
        .background(Color.adaptiveWhiteBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { toolbarTitle }
        }
        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        .task { loadCategories() }
        .onChange(of: transaction.type) { _, newValue in
            handleTypeChange(newValue)
        }
        
        .onChange(of: focusedField) { _, newValue in
            if newValue == nil {
                isEditing = false
            }
        }
        .toast(isShowing: $showToast, message: message ?? "")
        .sheet(isPresented: $showResultView) {
            ResultView(message: message ?? "", text: messageTitle ?? "", selectedTab: $selectedTab)
        }
    }
    
    private var toolbarTitle: some View {
        Text("edit_transaction")
            .foregroundStyle(.adaptiveBlack)
            .font(.headline)
            .fontWeight(.bold)
    }
    
    private var formFields: some View {
        VStack(spacing: 20) {
            rowField(label: "transaction_title_placeholder", text: Bindable(transaction).title, field: .title)
            rowField(label: "description", text: Bindable(transaction).text, field: .description, vertical: true)
            amountField
        }
    }
    
    private var pickerFields: some View {
        VStack(spacing: 20) {
            selectionRow(label: "transaction_type") {
                Menu {
                    Picker("", selection: Bindable(transaction).type) {
                        ForEach(Transaction.TransactionType.allCases) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                } label: {
                    HStack {
                        Text(transaction.type.localizedName)
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
                
                .tint(.primary)
            }
            .onTapGesture {
                isEditing = false
            }
            
            selectionRow(label: "category") {
                Menu {
                    Picker("", selection: Bindable(transaction).category) {
                        ForEach(categories) { category in
                            let localizedName = NSLocalizedString(category.categoryName, comment: "category")
                            Text(LocalizedStringKey(localizedName))
                                .tag(category as Category?)
                        }
                    }
                } label: {
                    HStack {
                        let name = transaction.category?.categoryName ?? ""
                                    Text(name.isEmpty ? "No Category" : NSLocalizedString(name, comment: ""))
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
                
                .foregroundStyle(.primary)
            }
            .onTapGesture {
                isEditing = false
            }
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 15) {
            Button("save_transaction") { saveChanges() }
                .modifier(ButtonNormal(buttonTitel: ""))
            
            Button("delete_transaction") { deleteTransaction() }
                .modifier(ButtonRed(buttonTitel: ""))
        }
        .padding(.horizontal)
    }
    
    private func rowField(label: String, text: Binding<String>, field: Field, vertical: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(label))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                TextField("", text: text, axis: vertical ? .vertical : .horizontal)
                    .disabled(!isEditing)
                    .focused($focusedField, equals: field)
                    .foregroundStyle(focusedField == field ? .primary : .secondary)
                
                Spacer()
                
                editToggleButton(for: field)
            }
            .padding(.vertical, 4)
            Divider().modifier(Line())
        }
        .padding(.horizontal)
    }
    
    private var amountField: some View {
        VStack(alignment: .leading) {
            Text("amount")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            
            HStack {
                TextField("", value: Bindable(transaction).amount, format: .number.precision(.fractionLength(2)))
                    .keyboardType(.decimalPad)
                    .disabled(!isEditing)
                    .focused($focusedField, equals: .amount)
                    .foregroundStyle(isEditing ? .primary : .secondary)
                    .fixedSize(horizontal: true, vertical: false)
                Text("€")
                    .foregroundStyle(isEditing ? .primary : .secondary)
                
                Spacer()
                
                editToggleButton(for: .amount)
            }
            .padding(.vertical, 4)
            Divider().modifier(Line())
        }
        .padding(.horizontal)
    }
    
    private func editToggleButton(for field: Field) -> some View {
        Button {
            withAnimation {
                isEditing = true
                focusedField = field
            }
        } label: {
            Image(systemName: (isEditing && focusedField == field) ? "checkmark.circle.fill" : "pencil")
                .font(.system(size: 22))
                .foregroundStyle((isEditing && focusedField == field) ? .green : .red)
        }
    }
    
    private func selectionRow<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(label))
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                content()
                Spacer()
            }
            .padding(.vertical, 4)
            Divider().modifier(Line())
        }
        .padding(.horizontal)
        
    }
    
    
    private func handleTypeChange(_ newValue: Transaction.TransactionType) {
        let newCats = (newValue == .income) ?
        CategoryFunctions.fetchCategoriesIncome(modelContext: modelContext) :
        CategoryFunctions.fetchCategoriesOutcome(modelContext: modelContext)
        self.categories = newCats
        self.transaction.category?.categoryName = newCats.first?.categoryName ?? ""
    }
    
    private func loadCategories() {
        categories = (transaction.type == .income) ?
        CategoryFunctions.fetchCategoriesIncome(modelContext: modelContext) :
        CategoryFunctions.fetchCategoriesOutcome(modelContext: modelContext)
    }
    
    func saveChanges() {
        Task {
            do {
                try await TransactionFunctions.editTransaction(
                    modelContext: modelContext,
                    transaction: transaction,
                    newCategoryKey: transaction.category?.categoryName ?? "",
                    newTitel: transaction.title,
                    newDescription: transaction.text,
                    newAmount: transaction.amount,
                    newType: transaction.type
                )
                handleCompletion(
                    error: nil,
                    successKey: "transaction_edit_success",
                    message: $message,
                    messageTitle: $messageTitle,
                    showResultView: $showResultView,
                    showToast: $showToast,
                    dismiss: dismiss,
                    onSuccess: {}
                )
            } catch {
                handleCompletion(
                    error: error,
                    successKey: "transaction_edit_success",
                    message: $message,
                    messageTitle: $messageTitle,
                    showResultView: $showResultView,
                    showToast: $showToast,
                    dismiss: dismiss,
                    onSuccess: {}
                )
            }
        }
    }
    
    func deleteTransaction() {
        Task {
            do {
                try await TransactionFunctions.deleteTransaction(
                    modelContext: modelContext,
                    transaction: transaction,
                    newCategoryKey: transaction.category?.categoryName ?? "",
                )
                handleCompletion(
                    error: nil,
                    successKey: "transaction_delete_success",
                    message: $message,
                    messageTitle: $messageTitle,
                    showResultView: $showResultView,
                    showToast: $showToast,
                    dismiss: dismiss,
                    onSuccess: {}
                )
            } catch {
                handleCompletion(
                    error: error,
                    successKey: "transaction_delete_success",
                    message: $message,
                    messageTitle: $messageTitle,
                    showResultView: $showResultView,
                    showToast: $showToast,
                    dismiss: dismiss,
                    onSuccess: {}
                )
            }
        }
    }
}
    
    


#Preview {
    
    @Previewable @State var selectedTab = 0
    
    let transaction = Transaction(title: "Test", text: "Description", amount: 5, type: .income)
    
    NavigationStack {
        EditTransactionView(selectedTab: $selectedTab, transaction: transaction)
    }
}

