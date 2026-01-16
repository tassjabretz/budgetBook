import SwiftUI



struct ContentView: View {
    

    @State private var selectedTab = 0
    
    @Environment(\.modelContext) var modelContext
   
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
      
   
        Group {
            TabView(selection: $selectedTab) {
                
             
                NavigationStack {
                    Home(selectedTab: $selectedTab)
                        .navigationTitle("transaktionen")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
                        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
                }
                .tabItem {
                    Label("transaktionen_tab", systemImage: "house.fill")
                }
                .tag(0)
                    
 
                NavigationStack {
                    AddTransactionView(selectedTab: $selectedTab)
                        .navigationTitle("add_transaction")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
                        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
                }
                .tabItem {
                    Label("add_transaction", systemImage: "plus.circle")
                }
                .tag(1)
                
               
                NavigationStack {
                    Settings(selectedTab: $selectedTab)
                        .navigationTitle("settings")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
                        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
                }
                .tabItem {
                    Label("settings", systemImage: "gearshape")
                }
                .tag(2)
            }
        }
        
        .onAppear {
                        
              
                        CategoryFunctions().checkAndResetMonthlyBudget(modelContext: modelContext)
                        
                    }
    
        

        
        .tint(.adaptiveBlack)
        

        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Finanzomat")
                    .foregroundColor(.adaptiveBlack)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
    }
}

#Preview {
    Home(selectedTab:.constant(0))
}

