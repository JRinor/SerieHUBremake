import SwiftUI

struct ProductionView: View {
    let series: Series
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                if let networks = series.networks, !networks.isEmpty {
                    DetailSection(title: "Réseaux", items: networks)
                }
                
                if let productionCompanies = series.productionCompanies, !productionCompanies.isEmpty {
                    DetailSection(title: "Sociétés de production", items: productionCompanies)
                }
                
                if let originCountry = series.originCountry, !originCountry.isEmpty {
                    DetailSection(title: "Pays d'origine", items: originCountry)
                }
                
                if let status = series.status {
                    DetailRow(title: "Statut", value: status)
                }
            }
            .padding()
        }
    }
}

struct DetailSection: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            ForEach(items, id: \.self) { item in
                Text(item)
                    .foregroundColor(.white)
            }
        }
    }
}
