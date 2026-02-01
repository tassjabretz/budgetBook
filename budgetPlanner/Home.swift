import SwiftUI

struct Home: View {
    @Environment(\.modelContext) var modelContext
    @State var transactions: [Transaction] = []
    @State var budgetBooks: [BudgetBook] = []
    @Binding var selectedTab: Int

    @State private var isLoading = true
    
    
    @State private var showToast = false
    @State private var message: String?
    @State private var messageTitle: String?
    @State private var showResultView = false
    
    @Environment(\.dismiss) var dismiss
    
    
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.adaptiveWhiteBackground.ignoresSafeArea()
                
                if isLoading {
                    
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.adaptiveWhiteBackground)
                        Text("loading_transactions")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                } else if transactions.isEmpty {
                    
                    EmptyView(selectedTab: $selectedTab)
                        .padding()
                } else {
                    
                    
                    transactionListContent
                    
                }
            }
            .toast(isShowing: $showToast, message: message ?? "")
            .sheet(isPresented: $showResultView) {
                ResultView(message: message ?? "", text: messageTitle ?? "", selectedTab: $selectedTab)
            }
            
            .task {
                let fetchedTransactions = TransactionFunctions.fetchTransactions(modelContext: modelContext)
                
                
                withAnimation(.easeInOut) {
                    self.transactions = fetchedTransactions
                    self.isLoading = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Finanzomat")
                        .foregroundColor(.adaptiveBlack)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        }
        
        
        
    }
    
    private var transactionListContent: some View {
        
        List {
            ForEach(transactions) { transaction in // Nutze direkt das Objekt statt Index
                NavigationLink(destination: EditTransactionView(selectedTab: $selectedTab, transaction: transaction)) {
                    TransactionCard(transaction: transaction)
                }
                // .listRowInsets(EdgeInsets()) // 1. Entfernt das innere Padding der Zeile
                .listRowBackground(Color.clear) // Macht den Zellen-Hintergrund unsichtbar
                .listRowSeparator(.hidden)
                .navigationLinkIndicatorVisibility(.hidden)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        deleteTransaction(transaction: transaction)
                    } label: {
                        Label("delete_transaction", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        
    }
    
    
    func deleteTransaction(transaction: Transaction) {
        
        Task {
            do {
                try await TransactionFunctions.deleteTransaction(
                    modelContext: modelContext,
                    transaction: transaction,
                    newCategoryKey: transaction.category?.categoryName ?? "")
                handleCompletion(
                    error: nil,
                    successKey: "transaction_delete_success",
                    message: $message,
                    messageTitle: $messageTitle,
                    showResultView: $showResultView,
                    showToast: $showToast,
                    dismiss: dismiss,
                    onSuccess: {
                        self.transactions.removeAll { $0.id == transaction.id }
                    }
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
            )}
                
            
           
        }
    }
    
}


#Preview {
    @Previewable @State var selectedTab = 0
    Home(selectedTab: $selectedTab)
}
