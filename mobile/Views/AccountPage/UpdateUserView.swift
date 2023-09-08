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
    
    var body: some View {
        VStack {
            Text("Update User Profile")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Here you can update your user profile information.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            // TODO: Implement user update form
            
            Spacer()
        }
    }
}

struct UpdateUserView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserView()
    }
}
