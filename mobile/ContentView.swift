//
//  ContentView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""
    @State private var refreshToken: String?
    @State private var accessToken: String?
    @State private var errorMessage: String?
    @State private var hasAccount: Bool = false
    
    var body: some View {
        
        Group {
            if hasAccount {
                signInView
            } else {
                signUpView
            }
        }
        .onAppear {
            // You can also fetch access token here if needed on app launch
        }
    }
    
    func signIn() {
        // Fetch refresh token
        APIManager.fetchRefreshToken(email: email, password: password) { result in
            switch result {
            case .success(let apiResponse):
                // Save refresh token and fetch access token
                self.refreshToken = apiResponse.message
                self.errorMessage = nil
                fetchAccessToken()
                return
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func signUp() {
        // Create account, fetch tokens and and sign in
        APIManager.createAccount(email: email, firstName: firstName, lastName: lastName, password: password, passwordConfirmation: passwordConfirmation) { result in
            switch result {
            case .success(let apiResponse):
                self.errorMessage = nil
                print("Successfully created account: \(apiResponse.message)")
                //verify()
                fetchAccessToken()
                verify()
                print("Successfully signed in")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func verify() {
        print("Started verify: \(email) \(password)")
        APIManager.verifyAccount(email: email, password: password) { result in
            switch result {
            case .success(let apiResponse):
                self.refreshToken = apiResponse.message
                self.errorMessage = nil
                print("Successfully verified account. Refresh token is: \(apiResponse.message)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchAccessToken() {
        guard let refreshToken = self.refreshToken else {
            self.errorMessage = "No Refresh Token available"
            return
        }
        APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let apiResponse):
                self.accessToken = apiResponse.message
                self.errorMessage = nil
                return
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
        
    @ViewBuilder
    private var signInView: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(Color("PrimaryColor"))
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    signIn()
                }
                Button("Don't have an account yet?") {
                    self.hasAccount = false
                }
                .padding()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(Color("AlertColor"))
                        .padding()
                }
            }
            .padding()
            .background(Color("BgColor"))
            .foregroundColor(Color("FgColor"))
        }
    }
    
    @ViewBuilder
    private var signUpView: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(Color("PrimaryColor"))
                Text("Sign up for embloy")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            
                TextField("First name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Last name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Confirm password", text: $passwordConfirmation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Create new account") {
                    signUp()
                }
                Button("Already have an account?") {
                    self.hasAccount = true
                }
                .padding()
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(Color("AlertColor"))
                        .padding()
                }
            }
            .padding()
            .background(Color("BgColor"))
            .foregroundColor(Color("FgColor"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
