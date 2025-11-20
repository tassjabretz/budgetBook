

import SwiftUI
import SwiftData

struct ContentView: View {

    var body: some View {
        
        TabView {
            
            NavigationStack {
                
                Home()
                    .navigationTitle("transaktionen")
                
            }
            
            .tabItem {
                Label("transaktionen", systemImage: "house")
                    
            }
           
            
            NavigationStack {
                AddTransactionView()
                    .navigationTitle("transaktionen_hinzufügen") 
            }
            
            .tabItem {
                Label("transaktionen_hinzufügen", systemImage: "plus.circle")
            }
            
            NavigationStack {
                AddBudgetBookView()
                    .navigationTitle(Text("add_book_title"))
            }
            .tabItem {
                Label("add_book", systemImage: "book")
            }
            
            NavigationStack {
                Settings()
                    .navigationTitle(Text("einstellungen"))
            }
            
            .tabItem {
                Label("einstellungen", systemImage: "gearshape")
            }
            
            
           
        }
        
        
        
        .accentColor(.blueback)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .toolbar {
  
            ToolbarItem(placement: .principal) {
                Text("haushalstbuch")
                    .foregroundColor(.black)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
            }
        }
        .toolbarBackground(
            Color.blueback,
            for: .navigationBar, .tabBar
        )
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
    }
}

#Preview {
    ContentView()
}
