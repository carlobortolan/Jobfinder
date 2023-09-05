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
                SignInForm(hasAccount: $hasAccount)
            } else {
                SignUpForm(hasAccount: $hasAccount)
            }
        }
        .onAppear {
            // Fetch access token here if needed on app launch
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        LoginView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)

    }
}
