import SwiftUI

struct AuthenticationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            // Arrière-plan amélioré
            RadialGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))]),
                           center: .topLeading,
                           startRadius: 100,
                           endRadius: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            // Formes décoratives
            GeometryReader { geometry in
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.1)
                
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4)
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.85)
            }
            
            VStack(spacing: 30) {
                Text(isSignUp ? "Inscription" : "Connexion")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "Email", text: $email, imageName: "envelope")
                    CustomTextField(placeholder: "Mot de passe", text: $password, imageName: "lock", isSecure: true)
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    // Logique de connexion/inscription
                }) {
                    Text(isSignUp ? "S'inscrire" : "Se connecter")
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        )
                }
                .padding(.horizontal, 20)
                
                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Déjà un compte ? Se connecter" : "Pas de compte ? S'inscrire")
                        .foregroundColor(.white)
                        .underline()
                }
                
                Spacer()
            }
            .padding()
            
            // Bouton pour fermer la vue
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .padding()
                    }
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            UINavigationController.attemptRotationToDeviceOrientation()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let imageName: String
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.white)
                .frame(width: 30)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        )
        .autocapitalization(.none)
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
