import SwiftUI

struct SerieItemView: View {
    let serie: Series
    
    var body: some View {
        VStack {
            AsyncImage(url: serie.imageUrl) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 100, height: 150)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 150)
                        .clipped()
                case .failure(_):
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 150)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
            Text(serie.name)
                .font(.caption)
                .lineLimit(1)
                .frame(width: 100)
            
            Text(String(format: "%.1f", serie.voteAverage))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 100)
    }
}
