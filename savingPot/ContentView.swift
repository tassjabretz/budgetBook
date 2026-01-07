import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selectedTab = 0

    var body: some View {

        
        TabView(selection: $selectedTab) {
            
            // 1. Home Tab (Transaktionen)
            NavigationStack {
                Home(selectedTab: $selectedTab)
                    .navigationTitle("transaktionen")
            }
            .tabItem {
              
                Label("transaktionen_tab", systemImage: "house.fill")
                    .accessibilityLabel("transaktionen_tab")
            }
            .tag(0)
                
          
            NavigationStack {
                AddTransactionView(selectedTab: $selectedTab)
                    .navigationTitle("add_transaction")
            }
            .tabItem {
               
                Label("add_transaction", systemImage: "plus.circle")
                    .accessibilityLabel("transaktionen")
            }
            .tag(1)
            
          
         
            
            NavigationStack {
                Settings(selectedTab: $selectedTab)
                    .navigationTitle(Text("settings"))
            }
            .tabItem {
                Label("settings", systemImage: "gearshape")
                    .accessibilityLabel("settings")
            }
            .tag(3)
        }

        
        .accentColor(.black )
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("budgetBook")
                    .foregroundColor(.black)
                    .font(.title)
                    .fontWeight(.bold)
            }
        }
        .toolbarBackground(
            Color.adaptiveGray,
            for: .navigationBar, .tabBar
        )
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
    }
}

#Preview {
    ContentView()
}
