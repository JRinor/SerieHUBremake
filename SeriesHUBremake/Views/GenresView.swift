import SwiftUI

struct GenresView: View {
    let genres: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(genres, id: \.self) { genre in
                    Text(genre)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}
