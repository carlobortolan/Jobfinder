import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager

    @State private var isLoading = false

    var body: some View {
        VStack {
                Text("User Profile")
                    .font(.largeTitle)
                Text("Name: \(authenticationManager.current.firstName) \(authenticationManager.current.lastName)")
                Text("Email: \(authenticationManager.current.email)")
                Spacer()
            }.onAppear {
                loadProfile(iteration: 0)
            }
        }
        
    
    func loadProfile(iteration: Int) {
        print("Iteration \(iteration)")
        isLoading = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchAccount(accessToken: accessToken) { result in
                switch result {
                case .success(let userResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.authenticationManager.current = userResponse.user
                        self.errorHandlingManager.errorMessage = nil
                        isLoading = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("case .failure, iteration: \(iteration)")
                        if iteration == 0 {
                            if case .authenticationError = error {
                                print("case .authenticationError")
                                // Authentication error (e.g., access token invalid)
                                // Refresh the access token and retry the request
                                self.authenticationManager.fetchAccessToken()
                                
                                self.loadProfile(iteration: 1)
                            } else {
                                print("case .else")
                                // Handle other errors
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                        }
                        isLoading = false
                    }
                }
            }
        }
    }
}
