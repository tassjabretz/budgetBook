//
//  savingPotApp.swift
//  savingPot
//
//  Created by Tassja Bretz on 02.10.25.
//

import SwiftUI
import SwiftData


@main
struct savingPotApp: App {
    
    @StateObject private var navigationManager = NavigationManager()
    @AppStorage("isDarkModeActive") var isDarkModeActive: Bool = false
    
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
            ContentView()
                .environmentObject(navigationManager)
                .preferredColorScheme(isDarkModeActive ? .dark : .light)
        }
        
        
        .modelContainer(sharedModelContainer)
    }
}
