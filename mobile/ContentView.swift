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
    @State private var refreshToken: String?
    @State private var accessToken: String?
    @State private var errorMessage: String?
    
    var body: some View {
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
     
    // Check if current refresh token is valid
    func checkTokenValidity() -> Bool {
        guard let refreshToken = self.refreshToken else {
            self.errorMessage = "No Refresh Token available"
            return false
        }
        
        return true
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
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
