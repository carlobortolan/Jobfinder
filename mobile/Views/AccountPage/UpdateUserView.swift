//
//  UpdateUserView.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct UpdateUserView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    
    @Binding var user: User
    @State private var isUpdating = false
        
    var body: some View {
        VStack {
            Text("Update Profile")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Here you can update your user profile information.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            if isUpdating {
                ProgressView()
            } else {
                Form {
                    Section(header: Text("Personal Information")) {
                        TextField("Email", text: $user.email)
                            .keyboardType(.emailAddress)
                        
                        TextField("First Name", text: $user.firstName)
                        TextField("Last Name", text: $user.lastName)
                        TextField("Phone Number", text: Binding(
                            get: { user.phone ?? "" },
                            set: { user.phone = $0 }
                        ))
                        TextField("Date of Birth", text: Binding(
                            get: { user.dateOfBirth ?? "" },
                            set: { user.dateOfBirth = $0 }
                        ))
                    }
                    
                    Section(header: Text("Address Information")) {
                        TextField("Address", text: Binding(
                            get: { user.address ?? "" },
                            set: { user.address = $0 }
                        ))
                        TextField("City", text: Binding(
                            get: { user.city ?? "" },
                            set: { user.city = $0 }
                        ))
                        TextField("Postal Code", text: Binding(
                            get: { user.postalCode ?? "" },
                            set: { user.postalCode = $0 }
                        ))
                        TextField("Country Code", text: Binding(
                            get: { user.countryCode ?? "" },
                            set: { user.countryCode = $0 }
                        ))
                    }
                }
                
                Button(action: {
                    // TODO: Implement user update logic
                    updateUser(iteration: 0)
                }) {
                    Text("Update Profile")
                }
                .disabled(isUpdating)
            }
            
            Spacer()
        }.onAppear(

        )
    }
    
    func updateUser(iteration: Int) {
        print("Iteration \(iteration)")
        isUpdating = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.updateAccount(accessToken: accessToken, user: authenticationManager.current) { result in
                switch result {
                case .success(let apiResponse):
                    DispatchQueue.main.async {
                        print("case .success \(apiResponse)")
                        self.errorHandlingManager.errorMessage = nil
                        isUpdating = false
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
                                        self.updateUser(iteration: 1)
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
                        isUpdating = false
                    }
                }
            }
        }
    }
}


struct UpdateUserView_Previews: PreviewProvider {
    static var previews: some View {
        @State var user = User.generateRandomUser()
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        UpdateUserView(user: $user).environmentObject(errorHandlingManager).environmentObject(authenticationManager)
    }
}
