import SwiftUI

struct FullAppTourView: View {

    @State var selectedTab = 0

    
    var body: some View {
        TabView(selection: $selectedTab) {
            OnboardingView(imageName: "overview", text: NSLocalizedString("onboarding_overview", comment: ""), selectedTab: $selectedTab)
                .tag(0)
            OnboardingView(imageName: "add_transaction", text: NSLocalizedString("onboarding_add_transaction", comment: ""), selectedTab: $selectedTab)
                .tag(1)
            OnboardingView(imageName: "edit_transaction", text: NSLocalizedString("onboarding_edit_transaction", comment: ""), selectedTab: $selectedTab)
                .tag(2)
            OnboardingView(imageName: "categories_income", text: NSLocalizedString("onboarding_categories_income", comment: ""), selectedTab: $selectedTab)
                .tag(3)
            OnboardingView(imageName: "categories_outcome", text: NSLocalizedString("onboarding_categories_outcome", comment: ""), selectedTab: $selectedTab)
                .tag(4)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}
