import SwiftUI
import SwiftData

struct Categories: View {
    let isOutcome: Bool
    @Environment(\.modelContext) var modelContext
    @Binding var selectedTab: Int
    
    
    @Query var categories: [Category]

    @State private var showToast: Bool = false
    @State private var message: String?

    
    init(isOutcome: Bool, selectedTab: Binding<Int>) {
        self.isOutcome = isOutcome
        self._selectedTab = selectedTab
        
        let predicate = #Predicate<Category> { $0.isOutgoing == isOutcome }
        _categories = Query(filter: predicate, sort: \.categoryName)
    }
    
    var body: some View {
        
        let navTitel = isOutcome ? "categories_outcome" : "categories_income"
        ScrollView {
            VStack(alignment: .leading) {
                
                let uiTrigger = categories.reduce(0) { $0 + $1.currentBudget }
                ForEach(categories) { category in
                    CategoryRow(
                        isOutcome: category.isOutgoing,
                        category: category,
                        selectedTab: $selectedTab,
                        onSave: { message in
                            self.message = message
                            withAnimation {
                                self.showToast = true
                            }
                        }
                    )
                }
            }
        }
        .id(categories.reduce(0) { $0 + ($1.currentBudget ?? 0) })
               
                .onAppear {
                    try? modelContext.save()
                }
        .toast(isShowing: $showToast, message: message ?? "")
        .overlay {
            if categories.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
        .task {
            do {
                let initialCheck = try modelContext.fetch(FetchDescriptor<Category>())
                if initialCheck.isEmpty {
                    CategoryFunctions().applyCategories(modelContext: modelContext)
                }
            } catch {
                print("Initial data check failed: \(error)")
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.adaptiveWhiteBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(NSLocalizedString(navTitel, comment: "navTitel"))
                    .foregroundColor(.adaptiveBlack)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
    }
}

#Preview {
    
    NavigationStack {
        Categories(isOutcome: true, selectedTab: .constant(0))
    }

}
