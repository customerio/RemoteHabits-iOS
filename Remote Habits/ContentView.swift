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

    var body: some View {
        VStack {
            if isLoggingIn.wrappedValue {
                ProgressView("Simulating logging in...")
            } else {
                let identifiedEmail = loggedInState.loggedInProfile?.email

                TextField("First name", text: $firstName).padding()
                TextField("Email address", text: $emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()

                Button("Generate random profile") {
                    firstName = String.random
                    emailAddress = EmailAddress.randomEmail
                }.padding()

                if fieldsPopulated.wrappedValue {
                    Button("Identify customer") {
                        profileViewModel.loginUser(email: emailAddress, password: "123", firstName: firstName)
                    }.padding()
                }

                Text(identifiedEmail != nil ? "Identified profile: \(identifiedEmail!)" : "not logged in")
                Text(loggedInState.error?.localizedDescription ?? "no error")

                Button("Crash app!") {
                    let numbers = [0]
                    _ = numbers[1]
                }.padding().accentColor(.red)
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
