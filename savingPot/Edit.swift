import SwiftUI
import SwiftData

struct Edit: View {
    @Binding var selectedTab: Int
    let transaction: Transaction
    
    // State-Variablen
    @State var titel: String
    @State var descriptionText: String
    @State var selectedCategoryName: String
    @State var selectedTransactionType: Transaction.TransactionType
    @State var amount: Double
    @State var categories: [Category] = []
    
    // UI-Zustände
    @State private var showToast = false
    @State private var message: String?
    @State private var messageTitle: String?
    @State private var showResultView = false
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    init(transaction: Transaction, selectedTab: Binding<Int>) {
        self.transaction = transaction
        self._selectedTab = selectedTab
        _titel = State(initialValue: transaction.titel)
        _descriptionText = State(initialValue: transaction.text)
        _selectedCategoryName = State(initialValue: transaction.category?.categoryName ?? "")
        _selectedTransactionType = State(initialValue: transaction.type)
        _amount = State(initialValue: transaction.amount)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Aufteilung in 3 klare Blöcke
                formFields
                pickerFields
                actionButtons
            }
            .padding(.top)
        }
        .background(Color.lightblue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { toolbarTitle }
        }
        .task { loadCategories() }
        .onChange(of: selectedTransactionType) { _, newValue in
            handleTypeChange(newValue)
        }
        .toast(isShowing: $showToast, message: message ?? "")
        .sheet(isPresented: $showResultView) {
            ResultView(message: message ?? "", text: messageTitle ?? "", selectedTab: $selectedTab)
        }
    }

    // --- SUBVIEWS ---

    private var toolbarTitle: some View {
        Text("edit_transaction")
            .foregroundStyle(.adaptiveBlack)
            .font(.headline).fontWeight(.bold)
    }

    private var formFields: some View {
        VStack(spacing: 20) {
            rowField(label: "transaction_title_placeholder", text: $titel)
            rowField(label: "description", text: $descriptionText, vertical: true)
            amountField
        }
    }

    private var pickerFields: some View {
        VStack(spacing: 20) {
            // Type Selection
            selectionRow(label: "transaction_type") {
                Menu {
                    Picker("", selection: $selectedTransactionType) {
                        ForEach(Transaction.TransactionType.allCases) { type in
                            Text(type.localizedName).tag(type)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedTransactionType.localizedName)
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
                .tint(.lightbluedarkmodeText)
            }

            // Category Selection
            selectionRow(label: "Category") {
                Menu {
                    Picker("", selection: $selectedCategoryName) {
                        ForEach(categories) { category in
                            Text(category.categoryName).tag(category.categoryName)
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategoryName.isEmpty ? "No Category" : selectedCategoryName)
                        Image(systemName: "chevron.up.chevron.down")
                    }
                }
                .foregroundStyle(.adaptiveBlack)
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 15) {
            Button("edit_transaction") { saveChanges() }
                .modifier(ButtonNormal(buttonTitel: ""))
            
            Button("delete_transaction") { deleteTransaction() }
                .modifier(ButtonRed(buttonTitel: ""))
        }
        .padding(.horizontal)
    }

    // --- REUSABLE COMPONENTS ---

    private func rowField(label: String, text: Binding<String>, vertical: Bool = false) -> some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(label)).font(.subheadline).foregroundStyle(.adaptiveGray)
            HStack {
                TextField("", text: text, axis: vertical ? .vertical : .horizontal)
                Spacer()
                Image(systemName: "pencil")
            }
            .foregroundStyle(.adaptiveBlack)
            Divider().modifier(Line())
        }
        .padding(.horizontal)
    }

    private var amountField: some View {
        VStack(alignment: .leading) {
            Text("amount").font(.subheadline).foregroundStyle(.adaptiveGray)
            HStack {
                TextField("", value: $amount, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                Spacer()
                Image(systemName: "pencil")
            }
            .foregroundStyle(.adaptiveBlack)
            Divider().modifier(Line())
        }
        .padding(.horizontal)
    }

    private func selectionRow<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(label)).font(.subheadline).foregroundStyle(.secondary)
            HStack {
                content()
                Spacer()
                Image(systemName: "pencil")
            }
            Divider().modifier(Line())
        }
        .padding(.horizontal)
    }

    // --- LOGIC ---

    private func handleTypeChange(_ newValue: Transaction.TransactionType) {
        let newCats = (newValue == .income) ?
            CategoryFunctions().fetchCategoriesIncome(modelContext: modelContext) :
            CategoryFunctions().fetchCategoriesOutcome(modelContext: modelContext)
        self.categories = newCats
        self.selectedCategoryName = newCats.first?.categoryName ?? ""
    }

    private func loadCategories() {
        categories = (selectedTransactionType == .income) ?
            CategoryFunctions().fetchCategoriesIncome(modelContext: modelContext) :
            CategoryFunctions().fetchCategoriesOutcome(modelContext: modelContext)
    }

    func saveChanges() {
        TransactionFunctions().editTransaction(modelContext: modelContext, transaction: transaction, newCategoryKey: selectedCategoryName, newTitel: titel, newDescription: descriptionText, newAmount: amount, newType: selectedTransactionType) { error in
            handleCompletion(error: error, successKey: "transaction_edit_success")
        }
    }

    func deleteTransaction() {
        TransactionFunctions().deleteTransaction(modelContext: modelContext, transaction: transaction) { error in
            handleCompletion(error: error, successKey: "transaction_delete_success")
        }
    }

    private func handleCompletion(error: Error?, successKey: String) {
        if let error = error {
            message = error.localizedDescription
            messageTitle = "Fehler"
            showResultView = true
        } else {
            message = NSLocalizedString(successKey, comment: "")
            withAnimation { showToast = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { dismiss() }
        }
    }
}
