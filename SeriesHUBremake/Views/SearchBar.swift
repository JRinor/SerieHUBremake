import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)

                TextField("Rechercher une série...", text: $text)
                    .foregroundColor(.white)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(10)
            .background(Color.white.opacity(0.15))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}
