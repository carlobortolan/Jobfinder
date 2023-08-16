//
//  ContentView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var query = ""
    @State private var refreshToken: String?
    @State private var accessToken: String?
    @State private var errorMessage: String?

    var body: some View {
        
        Group {
            if true {
                loginView
            } else {
                startView
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
            case .success(let refreshTokenResponse):
                // Save refresh token and fetch access token
                self.refreshToken = refreshTokenResponse.message
                self.errorMessage = nil
                self.fetchAccessToken()
                return
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func findJobs() {
        // Fetch refresh token
       /* APIManager.findJobs(query: query) { result in
            switch result {
            case .success(let refreshTokenResponse):
                return
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }*/
    }


    func fetchAccessToken() {
        guard let refreshToken = self.refreshToken else {
            self.errorMessage = "No Refresh Token available"
            return
        }
        APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let accessTokenResponse):
                self.accessToken = accessTokenResponse.message
                self.errorMessage = nil
                return
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func fetchAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = self.refreshToken else {
            self.errorMessage = "No Refresh Token available"
            completion(false)
            return
        }
        
        APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let accessTokenResponse):
                self.accessToken = accessTokenResponse.message
                self.errorMessage = nil
                completion(true) // Successful access token retrieval
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                completion(false) // Access token invalid -- need to renew refresh token first
            }
        }
    }
    
    @ViewBuilder
    private var loginView: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(Color("PrimaryColor"))
                Text("Login / Signup")
                    .font(.largeTitle)
                    .padding()

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Login with Existing Account") {
                    signIn()
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
    private var startView: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(Color("PrimaryColor"))
                Text("Welcome to embloy")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Search for job", text: $query)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("GO") {
                    findJobs()
                }
                .padding()
                
                Text("Your jobs: ...")
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
