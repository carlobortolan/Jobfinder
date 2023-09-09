//
//  ApplicationDetail.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct ApplicationDetail: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    var jobId: Int
    @State private var application: Application?

    var body: some View {
        VStack {
            if let application = application {
                Text(application.applicationText)
                    .padding()
                
                Text("Application Status: \(getStatusText(for: application.status))")
                    .foregroundColor(getStatusColor(for: application.status))
                    .padding()
                
                if let response = application.response {
                    Text("Response: \(response == "null" ? "No response yet ..." : response)")
                        .padding()

                }
            } else {
                Text("Loading application details...")
            }
        }
        .onAppear {
            applicationManager.loadApplication(iteration: 0, jobId: jobId) { application in
                if let application = application {
                    self.application = application
                    print("Application found: \(application)")
                } else {
                    print("Application not found or error occurred")
                }
            }
        }
    }

    private func getStatusColor(for status: String) -> Color {
        switch status {
        case "-1": return Color("AlertColor")
        case "0": return Color("FgColor")
        case "1": return Color("SuccessColor")
        default: return Color.primary
        }
    }

    private func getStatusText(for status: String) -> String {
        switch status {
        case "-1": return "Rejected"
        case "0": return "Pending"
        case "1": return "Accepted"
        default: return "Unknown"
        }
    }
}

struct ApplicationDetail_Previews: PreviewProvider {
    static var previews: some View {
        @State var jobId = 2
        ApplicationDetail(jobId: jobId)
    }
}
