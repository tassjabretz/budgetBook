import SwiftUI

struct Settings: View {

    @AppStorage("isDarkModeActive") var isDarkModeActive: Bool = false
    @Environment(\.locale) var locale
    
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("categories")
                .padding(.bottom)
                .font(.title3)
                .foregroundStyle(Color.adaptiveBlack)
            
            VStack(alignment: .leading) {
                NavigationLink(destination: Categories(isOutcome: true, selectedTab: $selectedTab)) {
                    HStack(alignment: .center) {
                        Text("categories_outcome")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
                
                Divider()
                    .frame(height: 0.3)
                    .overlay(.secondary)
                
                NavigationLink(destination: Categories(isOutcome: false, selectedTab: $selectedTab)) {
                    HStack(alignment: .center) {
                        Text("categories_income")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                }
            }
            .background(Color.adaptiveWhiteCard)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 2)
            .padding(.bottom, 40)
            
            Text("app_settings")
                .font(.title3)
                .padding(.bottom)
                .foregroundStyle(Color.adaptiveBlack)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("darkmode")
                        .font(.headline)
                    Spacer()
                    Toggle(isOn: $isDarkModeActive) { }
                        .labelsHidden()
                        .tint(.red)
                }
                .padding()
                
                Divider()
                    .frame(height: 0.3)
                    .overlay(.secondary)
                
                HStack {
                    Button {
                        openAppSettings()
                    } label: {
                        Text("language")
                            .foregroundStyle(Color.adaptiveBlack)
                        Spacer()
                        Text(currentLanguageName)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.secondary)
                }
                .font(.headline)
                .padding()
            }
            .background(Color.adaptiveWhiteCard)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.09), radius: 5, x: 0, y: 2)
        }
        .foregroundColor(.adaptiveBlack)
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.adaptiveWhiteBackground)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("app_settings")
                    .foregroundColor(.adaptiveBlack)
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .toolbarBackground(Color.adaptiveGray, for: .navigationBar, .tabBar)
        .toolbarBackground(.visible, for: .navigationBar, .tabBar)
    }
    
    private var currentLanguageName: String {
        let languageCode = locale.language.languageCode?.identifier ?? "unknown"
        return locale.localizedString(forLanguageCode: languageCode) ?? languageCode.uppercased()
    }
    
    func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }
}
