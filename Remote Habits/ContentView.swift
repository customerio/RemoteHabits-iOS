import SwiftUI

struct ContentView: View {
    @StateObject var profileViewModel = DI.shared.profileViewModel

    private var loggedInState: ProfileViewModel.LoggedInProfileState {
        profileViewModel.loggedInProfileState
    }

    private var presentAlert: Binding<Bool> {
        binding { loggedInState.error != nil }
    }

    private var isLoggingIn: Binding<Bool> {
        binding { loggedInState.loggingIn }
    }

    private var fieldsPopulated: Binding<Bool> {
        binding { !firstName.isEmpty && !emailAddress.isEmpty }
    }

    @State private var firstName = ""
    @State private var emailAddress = ""
    @State private var generatedProfileRandomly = false

    var body: some View {
        VStack {
            if isLoggingIn.wrappedValue {
                ProgressView("Simulating logging in...")
            } else {
                let identifiedEmail = loggedInState.loggedInProfile?.email

                TextField("First name", text: $firstName) { isEditing in
                    print("FN editing? \(isEditing)")
                    if isEditing {
                        generatedProfileRandomly = false
                    }
                }.padding()
                TextField("Email address", text: $emailAddress) { isEditing in
                    print("EM editing? \(isEditing)")
                    if isEditing {
                        generatedProfileRandomly = false
                    }
                }
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()

                Button("Generate random profile") {
                    generatedProfileRandomly = true
                    firstName = String.random
                    emailAddress = EmailAddress.randomEmail
                }.padding()

                if fieldsPopulated.wrappedValue {
                    Button("Identify customer") {
                        profileViewModel.loginUser(email: emailAddress, password: "123", firstName: firstName,
                                                   generatedRandom: generatedProfileRandomly)
                    }.padding()
                }

                Text(identifiedEmail != nil ? "Identified profile: \(identifiedEmail!)" : "not logged in")
                Text(loggedInState.error?.localizedDescription ?? "no error")
            }
        }.alert(isPresented: presentAlert) {
            Alert(title: Text("Error"),
                  message: Text(loggedInState.error?.localizedDescription ?? ""),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView().preferredColorScheme(.dark)
        }
    }
}
