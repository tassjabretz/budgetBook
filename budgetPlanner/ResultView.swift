import SwiftUI

struct ResultView: View {
    
    
    let message: String
    let text: String
    @Binding var selectedTab: Int
    
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack() {
            Spacer()
            
            Image(systemName:"xmark.circle")
                .resizable()
                .frame(width: 150, height: 150)
                .foregroundColor(.red)
                .scaledToFit()
                .padding(.bottom, 40)
            
            
            Text(text)
                .font(.callout)
                .foregroundStyle(.adaptiveBlack)
            
            Text(message)
                .font(.caption)
                .foregroundStyle(.adaptiveBlack)
            
            Spacer()
            Button {
                dismiss() 
            } label: {
                Text("to_overview")
                    .modifier(ButtonNormal(buttonTitel: "to_overview"))
                    .foregroundStyle(.adaptiveWhiteCard)
            }
        }
        .padding()
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.adaptiveGray)
    }
    
    
    
}

#Preview {
    @Previewable @State var selectedTab = 0
    
    ResultView(message: "Error", text: "Hello", selectedTab: $selectedTab)
}
