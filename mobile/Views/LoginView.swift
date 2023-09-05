//
//  LoginView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct LoginView: View {
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
                Image("EmbloyLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("PrimaryColor"))
                Text("embloy")
                    .font(.largeTitle)
                    .padding()
                TextField("Email", text: $authenticationManager.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                SecureField("Password", text: $authenticationManager.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
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
                Image("EmbloyLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("PrimaryColor"))
                Text("Sign up for embloy")
                    .font(.largeTitle)
                    .padding()

                TextField("Email", text: $authenticationManager.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)

                TextField("First name", text: $authenticationManager.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Last name", text: $authenticationManager.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)

                SecureField("Password", text: $authenticationManager.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                SecureField("Confirm password", text: $authenticationManager.passwordConfirmation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)

                Button("Create new account") {
                    authenticationManager.signUp()
                }.padding(.top)
                Button("Already have an account?") {
                    self.hasAccount = true
                }.padding()
                
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        LoginView()            .environmentObject(errorHandlingManager).environmentObject(authenticationManager)

    }
}
