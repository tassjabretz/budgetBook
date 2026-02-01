import SwiftUI
import SwiftData

struct EmptyView: View {
    @State var scale: CGFloat = 1.0
    
    @Binding var selectedTab: Int

    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Spacer()
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.adaptiveBlack)
                    .scaleEffect(scale)
                    .padding()
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatCount(2,autoreverses: true)) {
                            
                            self.scale = 2
                        }
                    }
                Spacer()
                Text("no_transactions")
                    .padding(.vertical, 30)
                    .foregroundStyle(.adaptiveBlack)
                    .font(.title2)
                
                NavigationLink(destination: AddTransactionView(selectedTab: $selectedTab)) {
                    Text("add_transaction")
                }
                .modifier(ButtonNormal(buttonTitel: ""))
                .font(.title2)
                
                
                Spacer()
            }
            
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    
       
        
        @Previewable @State var selectedTab = 0

        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Transaction.self, Category.self, configurations: config)
    
 
    EmptyView(selectedTab: $selectedTab)
}
