//
//  SignInForm.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI

struct SignInForm: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @Binding var hasAccount: Bool

    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image("EmbloyLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color("PrimaryColor"))
                Text("embloy")
                    .font(.largeTitle)
                    .padding()
                TextField("Email", text: $authenticationManager.current.email)
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
                    hasAccount = false
                }
                .padding()
                Spacer()
            }
            //.padding()
            .background(Color("BgColor"))
            .foregroundColor(Color("FgColor"))
        }
    }
}

struct SignInForm_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        @State var hasAccount = true
        
        SignInForm(hasAccount: $hasAccount)
            .environmentObject(errorHandlingManager)
            .environmentObject(authenticationManager)
    }
}
