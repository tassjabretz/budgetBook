import SwiftUI

struct ImpressumView: View {
  
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Angaben gemäß § 5 TMG")) {
                    InfoRow(label: "Name", value: "Tassja Bretz")
                    InfoRow(label: "Straße", value: "Moorrand 8C")
                    InfoRow(label: "PLZ/Ort", value: "22455 Hamburg")
                }
                
                Section(header: Text("Kontakt")) {
                    InfoRow(label: "E-Mail", value: "tassja.bretz@gmail.com")
                    InfoRow(label: "Telefon", value: "+17645889465")
                }
                
                Section(header: Text("Rechtliches"), footer: Text("Plattform der EU-Kommission zur Online-Streitbeilegung: https://ec.europa.eu/consumers/odr/")) {
                                    Text("Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV:")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text("Tassja Bretz\nMoorand 8C\n22455 Hamburg")
                                        .font(.footnote)
                                }            }
            .navigationTitle("Impressum")
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ImpressumView()
        .environment(\.locale, Locale(identifier: "de"))
}
