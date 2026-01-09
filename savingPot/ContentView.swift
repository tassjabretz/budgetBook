import SwiftUI



struct ContentView: View {
    
    // MARK: - State & AppStorage
    @State private var selectedTab = 0
    
    // Wir beobachten den Dark Mode Status hier im Root.
    // Sobald dieser sich ändert, wird die View neu evaluiert.
    @AppStorage("isDarkModeActive") var isDarkModeActive: Bool = false

    var body: some View {
        // Wir wickeln alles in eine Group, um globale Modifikatoren zentral zu steuern
        Group {
            TabView(selection: $selectedTab) {
                
                // 1. Home Tab (Transaktionen)
                NavigationStack {
                    Home(selectedTab: $selectedTab)
                        .navigationTitle("transaktionen")
                        .navigationBarTitleDisplayMode(.inline)
                        // Lokale Hintergründe sorgen für Stabilität in den Unteransichten
                        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
                        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
                }
                .tabItem {
                    Label("transaktionen_tab", systemImage: "house.fill")
                }
                .tag(0)
                    
                // 2. Add Transaction Tab
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
                
                // 3. Settings Tab
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
        // --- DER FIX FÜR DIE VERZÖGERUNG ---
        
        // 1. .id() erzwingt einen kompletten Identitätswechsel der View bei Modus-Änderung.
        // Das ist die effektivste Methode, um hartnäckige Toolbar-Farben zu resetten.
        .id(isDarkModeActive)
        
        // 2. preferredColorScheme überschreibt das System-Verhalten sofort.
        .preferredColorScheme(isDarkModeActive ? .dark : .light)
        
        // 3. Animation sorgt für einen weichen Übergang statt eines harten Flackerns.
        .animation(.easeInOut(duration: 0.2), value: isDarkModeActive)
        
        .tint(.adaptiveBlack)
        
        // Globale Toolbar-Konfiguration
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("budgetBook")
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

