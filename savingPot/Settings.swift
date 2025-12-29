
import SwiftUI

struct Settings: View {

    @AppStorage("isDarkModeActive") var isDarkModeActive: Bool = false
    
    @Binding var selectedTab: Int
    var body: some View {

        VStack(alignment:.leading)
        {
            Text("categories")
                .padding(.bottom)
                .font(.title3)
            VStack(alignment: .leading) {
                NavigationLink(destination: Categories(isOutcome: true, selectedTab: $selectedTab)) {
                    HStack (alignment: .center)
                    {
                        
                        Text("categories_outcome")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.adaptiveBlack)
                    .padding()
                }
                Divider()
                    .frame(height: 1)
                    .overlay(.adaptiveBlack)
                
                
                
                NavigationLink(destination: Categories(isOutcome: false, selectedTab: $selectedTab)) {
                    
                    
                    HStack(alignment: .center)
                    {
                        
                        Text("categories_income")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    
                    
                    .padding()
                }
                
            }
            
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                
                    .stroke(.adaptiveBlack, lineWidth: 1)
                
                
            )
            .padding(.bottom, 40)
            
            Text("app_settings")
                .font(.title3)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                
                HStack {
                   
                    Text("darkmode")
                        .font(.headline)
                    
                    Spacer()
                    
                    Toggle(isOn: $isDarkModeActive) {
                        
                    }
                    .labelsHidden()
                }
                .padding()
                
                Divider()
                    .frame(height: 1)
                    .overlay(.adaptiveBlack)
                
                HStack {
                    
                    Button {
                        openAppSettings()
                        
                    }
                    label: {
                        
                        Text("language")
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                    }
                    
                }
               
                .font(.headline)
                .padding()
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                
                    .stroke(.adaptiveBlack, lineWidth: 1)
                
                
            )
        }
        .foregroundColor(.adaptiveBlack)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.lightblue)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("app_settings")
                        .foregroundColor(.adaptiveBlack)
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
            .toolbarBackground(
                Color.blueback,
                for: .navigationBar, .tabBar)
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
        
      
        
        
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
    Settings(selectedTab: .constant(2))
}
