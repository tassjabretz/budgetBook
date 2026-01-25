import SwiftUI

struct ImpressumView: View {
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Angaben gemäß § 5 TMG")) {
                    InfoRow(label: "Name", value: "Vorname Nachname")
                    InfoRow(label: "Straße", value: "Straße Hausnummer")
                    InfoRow(label: "PLZ/Ort", value: "PLZ Ort")
                }
                
                Section(header: Text("Kontakt")) {
                    InfoRow(label: "E-Mail", value: "email.email@email.com")
                    InfoRow(label: "Telefon", value: "+123456789")
                }
                
                Section(header: Text("Rechtliches"), footer: Text("Plattform der EU-Kommission zur Online-Streitbeilegung: https://ec.europa.eu/consumers/odr/")) {
                    Text("Verantwortlich für den Inhalt nach § 55 Abs. 2 RStV:")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Vorname Nachnachname\nStraße Hausnummer \n PLZ Or")
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
