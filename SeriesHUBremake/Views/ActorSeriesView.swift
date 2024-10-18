import SwiftUI

struct ActorSeriesView: View {
    let actor: CastMember
    @ObservedObject var viewModel: SeriesViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    backButton
                    Spacer()
                    Text("Séries avec \(actor.name)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()

                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else if viewModel.seriesByActor.isEmpty {
                    Text("Aucune série trouvée pour cet acteur.")
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(viewModel.seriesByActor) { serie in
                                NavigationLink(destination: SeriesDetailView(series: serie)) {
                                    SerieItemView(serie: serie)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
        .onAppear {
            viewModel.fetchSeriesByActor(actorId: actor.id)
        }
    }

    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
    }
}
