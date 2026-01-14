import SwiftUI

struct Home: View {
    @Environment(\.modelContext) var modelContext
    @State var transactions: [Transaction] = []
    @State var budgetBooks: [BudgetBook] = []
    @Binding var selectedTab: Int
    @State private var isLoading = true
    
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
             
                    ScrollView {
                        transactionListContent
                    }
                }
            }

            .task {
                let fetchedTransactions = TransactionFunctions().fetchTransactions(modelContext: modelContext)
                try? await Task.sleep(nanoseconds: 200_000_000)
                
                withAnimation(.easeInOut) {
                    self.transactions = fetchedTransactions
                    self.isLoading = false
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("budgetBook")
                        .foregroundColor(.adaptiveBlack)
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        }
    }
    
 
    private var transactionListContent: some View {
        VStack(alignment: .center) {
            
            
            ForEach(transactions.indices, id: \.self) { index in
                let transaction = transactions[index]
                NavigationLink(destination: EditTransactionView(transaction: transaction, selectedTab: $selectedTab)) {
                    TransactionCard(transaction: transaction)
                }
                
             
            }
        }
    
        .padding()
    }
    

}

#Preview {
    Home(selectedTab:.constant(0))
}
