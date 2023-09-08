//
//  AppInfoView.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct AppInfoView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    var body: some View {
        VStack {
            Text("About App")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Stay tuned!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Version: 1.0")
                .font(.body)
                .padding(.bottom)
            
            Spacer()
        }
    }
}
struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}
