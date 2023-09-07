//
//  SignUpForm.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI

struct SignUpForm: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @Binding var hasAccount: Bool

    var body: some View {
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

                TextField("Email", text: $authenticationManager.current.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.bottom)

                TextField("First name", text: $authenticationManager.current.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Last name", text: $authenticationManager.current.lastName)
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
            }
            //.padding()
            .background(Color("BgColor"))
            .foregroundColor(Color("FgColor"))
        }
    }
}

struct SignUpForm_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        @State var hasAccount = false
        
        SignUpForm(hasAccount: $hasAccount)
            .environmentObject(errorHandlingManager)
            .environmentObject(authenticationManager)
    }
}
