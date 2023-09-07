import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager

    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack {
                Text("User Profile")
                    .font(.largeTitle)
                
                Text("Name: \(authenticationManager.current.firstName) \(authenticationManager.current.lastName)")
                Text("Email: \(authenticationManager.current.email)")
                
                Group {
                    Text("Activity Status: \(authenticationManager.current.activityStatus)")
                    Text("Longitude: \(authenticationManager.current.longitude ?? 0.0)")
                    Text("Latitude: \(authenticationManager.current.latitude ?? 0.0)")
                    Text("Country Code: \(authenticationManager.current.countryCode ?? "n.a.")")
                    Text("Postal Code: \(authenticationManager.current.postalCode ?? "n.a.")")
                }
                
                Group {
                    Text("City: \(authenticationManager.current.city ?? "n.a.")")
                    Text("Address: \(authenticationManager.current.address ?? "n.a.")")
                    Text("Date of Birth: \(authenticationManager.current.dateOfBirth ?? "n.a.")")
                    Text("User Type: \(authenticationManager.current.userType)")
                }
                
                Group {
                    Text("View Count: \(authenticationManager.current.viewCount)")
                    Text("Created At: \(authenticationManager.current.createdAt)")
                    Text("Updated At: \(authenticationManager.current.updatedAt)")
                    Text("Applications Count: \(authenticationManager.current.applicationsCount)")
                    Text("Jobs Count: \(authenticationManager.current.jobsCount)")
                }
                
                Group {
                    Text("User Role: \(authenticationManager.current.userRole)")
                    Text("Application Notifications: \(authenticationManager.current.applicationNotifications ? "Enabled" : "Disabled")")
                    Text("Twitter URL: \(authenticationManager.current.twitterURL ?? "n.a.")")
                    Text("Facebook URL: \(authenticationManager.current.facebookURL ?? "n.a.")")
                    Text("Instagram URL: \(authenticationManager.current.instagramURL ?? "n.a.")")
                }
                
                Group {
                    Text("Phone: \(authenticationManager.current.phone ?? "n.a.")")
                    Text("Degree: \(authenticationManager.current.degree ?? "n.a.")")
                    Text("LinkedIn URL: \(authenticationManager.current.linkedinURL ?? "n.a.")")
                    Text("Image URL: \(authenticationManager.current.imageURL ?? "n.a.")")
                }
                
                Spacer()
            }
            .padding()
        }
        .onAppear {
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
                                self.authenticationManager.requestAccessToken() { accessTokenSuccess in
                                    if accessTokenSuccess{
                                        self.loadProfile(iteration: 1)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                    }
                                }
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
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            let errorHandlingManager = ErrorHandlingManager()
            let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
            authenticationManager.current = User.generateRandomUser()
            return ProfileView()
                .environmentObject(errorHandlingManager)
                .environmentObject(authenticationManager)
        }
    }
}
