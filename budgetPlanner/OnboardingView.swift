import SwiftUI

struct OnboardingView: View {
    
    let imageName: String
    let text: String
 
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @Binding var selectedTab: Int
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            
            HStack {
                Spacer()
                Button {
                  
                    hasCompletedOnboarding = true
                    dismiss()
                } label: {
                    roundImage(imageName: "xmark")
                }
                .padding()
            }
            .padding(.trailing)
            
    

            ImageAppTour(imageName: imageName)
              
            
            Text(text)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(20)
               
            
            Spacer()
            
           
            if selectedTab == 4 {
           

                Button {
                    hasCompletedOnboarding = true
                }
                
                label: {
                   
                    Text("Loslegen")
                        .modifier(ButtonNormal(buttonTitel: "Loslegen"))
                }
                .padding(40)
                
                
                Spacer()
                    
             
            }
        }
        .padding()
        .foregroundStyle(.adaptiveBlack)
        .background(Color(.adaptiveWhiteBackground))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    
  
   OnboardingView(imageName: "categories_outcome", text: "Organisere und Bearbeite das Budget deiner Ausgaben mit Kategorien", selectedTab: .constant(4))
      
}
