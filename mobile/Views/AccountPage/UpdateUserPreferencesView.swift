//
//  UpdateUserPreferencesView.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct UpdateUserPreferencesView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager

    var body: some View {
        VStack {
            Text("Update Preferences")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Customize your app experience by updating your preferences.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            // TODO: Implement user preferences update form
            
            Spacer()
        }
    }
}

struct UpdateUserPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        @State var user = User.generateRandomUser()
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        UpdateUserPreferencesView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)
    }
}
