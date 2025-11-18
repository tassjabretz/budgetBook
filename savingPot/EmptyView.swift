import SwiftUI

struct EmptyView: View {
    // 1. Initialize scale to a base value
    @State var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blueback)
                .scaleEffect(scale)
                .padding()
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatCount(2,autoreverses: true)) {
                       
                        self.scale = 2
                    }
                }
            Spacer()
            Text("no_transactions" )
                .padding(.vertical, 30)
            
            NavigationLink(destination: AddTransactionView()) {
                Text("add_transaction")
            }
            .modifier(ButtonNormal(buttonTitel: ""))


            Spacer()
        }

        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
   
    }
}

#Preview {
    EmptyView()
}
