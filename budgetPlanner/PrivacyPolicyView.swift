import SwiftUI


struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    headerSection
                    
                    Group {
                        PolicySection(title: "1. Datenschutz auf einen Blick", content: "Der Schutz Ihrer persönlichen Daten ist mir ein wichtiges Anliegen. Diese App ist so konzipiert, dass sie dem Grundsatz der Datensparsamkeit folgt. Alle Daten verbleiben primär unter Ihrer Kontrolle.")
                        
                        PolicySection(title: "2. Datenerfassung (SwiftData)", content: "Alle von Ihnen eingegebenen Finanzdaten (Transaktionen, Kategorien, Beträge) werden ausschließlich lokal auf Ihrem Gerät in einer geschützten Datenbank gespeichert.")
                        
                        PolicySection(title: "3. iCloud-Synchronisation", content: "Sofern aktiviert, werden Daten verschlüsselt über Apple-Server synchronisiert. Ich als Entwickler habe zu keinem Zeitpunkt Zugriff auf Ihre privaten Finanzdaten.")
                        
                        PolicySection(title: "4. Keine Drittanbieter", content: "Diese App verwendet keine Analyse-Tools (wie Google Analytics) und schaltet keine Werbung. Es findet kein Datentransfer an Dritte statt.")
                    }
                    
                    contactSection
                    
                    footerSection
                }
                .padding()
            }
            .navigationTitle("Datenschutz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        dismiss()
                    }
                }
            }
        }
    }
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Datenschutzerklärung")
                .font(.largeTitle.bold())
            Text("Stand: Januar 2026")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Verantwortliche Stelle").font(.headline)
            Text("Vorname Nachname\nStraße Hausnummer\nPLZ Ort\nemail@email.com")
                .font(.body)
        }
        .padding(.top, 10)
    }
    
    private var footerSection: some View {
        Text("Sie haben das Recht, jederzeit Auskunft über Ihre lokal gespeicherten Daten zu erhalten oder diese durch Löschen der App vollständig zu entfernen.")
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.top, 20)
    }
}


struct PolicySection: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    PrivacyPolicyView()
}


