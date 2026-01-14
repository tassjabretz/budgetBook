import SwiftUI
import SwiftData

struct Categories: View {
    let isOutcome: Bool
    @Environment(\.modelContext) var modelContext
    @Binding var selectedTab: Int
    

    
    @Query var categories: [Category]

    @State private var showToast: Bool = false
    @State private var message: String?

    @State private var showSheet = false
    

    @State private var messageTitle: String?
    @State private var showResultView = false
    
    
    
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
                
                ForEach(categories) { category in
                    CategoryRow(
                        isOutcome: category.isOutgoing,
                        category: category,
                        selectedTab: $selectedTab
                    )
                }
                Spacer()
                if(navTitel == "categories_outcome")
                {
                    HStack() {
                        Spacer()
                        Image(systemName: "info.circle")
                          
                        Text("information_linktext")
                        Spacer()
                    }
                    .padding()
                    .onTapGesture {
                        showSheet = true
                    }
                    .sheet(isPresented: $showSheet) {
                        VStack(alignment: .center) {
                     

                     
                                
                                VStack(alignment: .center) {
                                   Spacer()
                                    Image(systemName: "info.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.secondary)
                                        .padding()
                                    
                                    Text(LocalizedStringKey("info_categories"))
                                        .font(.body)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                    Spacer()

                                  

                                    
                                }
                                .padding()
                            
                        }
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                    }
                   
                }
                
            }
           
            
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
            ToolbarItem(placement: .topBarTrailing) {
                Text(NSLocalizedString("save", comment: "save"))
                    .foregroundColor(.adaptiveBlack)
                    .font(.caption)
                    
                    .onTapGesture {
                        saveBudget()
                    }
                    .padding(.horizontal)
            }
            
        }
        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
    }
    
    func saveBudget() {
        CategoryFunctions().saveAllCategories(modelContext: modelContext) { error in
            handleCompletion(error: error, successKey: "budget_updated_success")
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { }
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
         Categories(isOutcome: true, selectedTab: .constant(0))
            .modelContainer(container)
    }
}
