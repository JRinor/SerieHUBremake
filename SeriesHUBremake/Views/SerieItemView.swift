import SwiftUI

struct SerieItemView: View {
    let serie: Series
    
    var body: some View {
        VStack {
            AsyncImage(url: serie.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 150)
            
            Text(serie.name)
                .font(.caption)
                .lineLimit(1)
            
            Text(String(format: "%.1f", serie.voteAverage))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 100)
        .padding(.horizontal, 5)
    }
}
