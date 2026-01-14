import SwiftUI

struct Settings: View {
    
    @AppStorage("appearanceSelection") var appearanceSelection: Int = 0
    @Environment(\.locale) var currentLocale
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = true
    @Binding var selectedTab: Int
    
    
    var body: some View {
        ScrollView {
            
            
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
                .modifier(containerBorder())
            }
            VStack(alignment: .leading) {
                Text("app_settings")
                    .font(.title3)
                    .padding(.bottom)
                    .foregroundStyle(Color.adaptiveBlack)
                
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        
                        
                        Text("value")
                            .font(.headline)
                            .foregroundStyle(Color.adaptiveBlack)
                        
                        Spacer()
                        
                        Picker("Modus", selection: $appearanceSelection) {
                            ForEach(AppearanceMode.allCases) { mode in
                                HStack {
                                    Text(NSLocalizedString(mode.title, comment: ""))
                                    Image(systemName: mode.icon)
                                    
                                }.tag(mode.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.secondary)
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
                        
                        Divider()
                            .frame(height: 0.3)
                            .overlay(.secondary)
                    }
                    .font(.headline)
                    .padding()
                    
                    Divider()
                        .frame(height: 0.3)
                        .overlay(.secondary)
                    
                    NavigationLink(destination: ImpressumView()) {
                        HStack {
                            Text("Impressum")
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
                    NavigationLink(destination: PrivacyPolicyView()) {
                        HStack {
                            Text("Datenschutz")
                                .font(.headline)
                            Spacer()
                            
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                    }
                    
                    
                }
                .modifier(containerBorder())
               
                
            }
            
            VStack(alignment: .leading) {
                Text("app_infos")
                    .font(.title3)
                    .padding(.bottom)
                    .foregroundStyle(Color.adaptiveBlack)
                VStack(alignment: .leading) {
                    NavigationLink(destination: Categories(isOutcome: true, selectedTab: $selectedTab)) {
                        HStack(alignment: .center) {
                            Text("App-Tour")
                                .font(.headline)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                       
                    }
                    
                }
                .modifier(containerBorder())
            }
           
            
            
            
            
            .padding()
      
            
            
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
        let languageCode = currentLocale.language.languageCode?.identifier ?? "unknown"
        return currentLocale.localizedString(forLanguageCode: languageCode) ?? languageCode.uppercased()
    }
    
    func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }
}


#Preview {
    NavigationStack {
        Settings(
            selectedTab: .constant(0),
            
        )
        .environment(\EnvironmentValues.locale, Locale(identifier: "de"))
    }
}
