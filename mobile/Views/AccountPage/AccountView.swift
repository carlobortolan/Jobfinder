//
//  StartView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//
// ==> GET /user
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    
    var body: some View {
        
        Group {
            homeView
        }
//        .onAppear {
//            // You can also fetch access token here if needed on app launch
//        }
    }
    
        
    @ViewBuilder
    private var homeView: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(Color("PrimaryColor"))
                Text("Home")
                    .font(.largeTitle)
                    .padding()
                Button("Log out") {
                    authenticationManager.signOut()
                }
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


struct AccountView_Preview: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        AccountView()
            .environmentObject(errorHandlingManager).environmentObject(authenticationManager)
    }
}
