//
//  ContentView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager

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
                
                TextField("Email", text: $authenticationManager.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $authenticationManager.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    authenticationManager.signIn()
                }
                Button("Don't have an account yet?") {
                    self.hasAccount = false
                }
                .padding()
                
                if let errorMessage = errorHandlingManager.errorMessage {
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
                
                TextField("Email", text: $authenticationManager.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            
                TextField("First name", text: $authenticationManager.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Last name", text: $authenticationManager.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $authenticationManager.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                SecureField("Confirm password", text: $authenticationManager.passwordConfirmation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Create new account") {
                    authenticationManager.signUp()
                }
                Button("Already have an account?") {
                    self.hasAccount = true
                }
                .padding()
                
                if let errorMessage = errorHandlingManager.errorMessage {
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
