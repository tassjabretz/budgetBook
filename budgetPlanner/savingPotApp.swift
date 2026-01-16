import SwiftUI
import SwiftData

@main
struct savingPotApp: App {
    
    @StateObject private var navigationManager = NavigationManager()
    @AppStorage("appearanceSelection") var appearanceSelection: Int = 0
    
   
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    
  
    @State private var selectedTab: Int = 0

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Category.self,
            BudgetBook.self,
            Transaction.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Group {
                if !hasCompletedOnboarding {
     
                    TabView(selection: $selectedTab) {
                        OnboardingView(imageName: "overview", text: NSLocalizedString("onboarding_overview", comment: "onboarding_overview"), selectedTab: $selectedTab)
                            .tag(0)
                        OnboardingView(imageName: "add_transaction", text: NSLocalizedString("onboarding_add_transaction", comment: "onboarding_add_transaction"), selectedTab: $selectedTab)
                            .tag(1)
               
                        OnboardingView(imageName: "edit_transaction", text: NSLocalizedString("onboarding_edit_transaction", comment: "onboarding_edit_transaction"), selectedTab: $selectedTab)
                            .tag(2)
                        OnboardingView(imageName: "categories_income", text: NSLocalizedString("onboarding_categories_income", comment: "onboarding_categories_income"), selectedTab: $selectedTab)
                            .tag(3)
                        OnboardingView(imageName: "categories_outcome", text: NSLocalizedString("onboarding_categories_outcome", comment: "onboarding_categories_outcome"), selectedTab: $selectedTab)
                            .tag(4)
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                } else {
                   
                    ContentView()
                        .id(appearanceSelection)
                   
                }
            }
            
            .environmentObject(navigationManager)
            .preferredColorScheme(selectedScheme)
            .modelContainer(sharedModelContainer)
            
        }
    }
    var selectedScheme: ColorScheme? {
            switch appearanceSelection {
            case 1: return .light
            case 2: return .dark
            default: return nil
            }
        }
    
}


