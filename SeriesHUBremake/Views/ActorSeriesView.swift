import SwiftUI
import Combine

struct ActorSeriesView: View {
    let actor: CastMember
    @State private var series: [Series] = []
    @State private var cancellable: AnyCancellable? = nil
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {  // Ensure the view is inside a NavigationView
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

                ScrollView {
                    if series.isEmpty {
                        Text("Chargement des séries...")
                            .foregroundColor(.white)
                    } else {
                        ForEach(series) { serie in
                            NavigationLink(destination: SeriesDetailView(series: serie)) {
                                HStack {
                                    AsyncImage(url: serie.imageUrl) { phase in
                                        switch phase {
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 100, height: 150)
                                        default:
                                            Color.gray
                                                .frame(width: 100, height: 150)
                                        }
                                    }
                                    Text(serie.name)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.leading, 10)

                                    Spacer()
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .onAppear {
                fetchSeriesForActor(actorId: actor.id)
            }
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

    private func fetchSeriesForActor(actorId: Int) {
        cancellable = APIService().fetchSeriesByActor(actorId: actorId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Erreur lors de la récupération des séries: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { series in
                self.series = series
            })
    }
}
