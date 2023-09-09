//
//  OwnApplicationsView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI

struct OwnApplicationsView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.5, anchor: .center)
                } else {
                    if applicationManager.ownApplications.isEmpty {
                        Text("No applications yet.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    } else {
                        List(applicationManager.ownApplications, id: \.jobId) { application in
                            NavigationLink(
                                destination: ApplicationDetail(jobId: application.jobId),
                                label: {
                                    VStack(alignment: .leading) {
                                        Text(application.applicationText)
                                            .font(.headline)
                                        
                                        Text(getStatusText(status: application.status))
                                            .foregroundColor(getStatusColor(status: application.status))
                                            .font(.subheadline)
                                        
                                        if let response = application.response {
                                            Text("Response: \(response == "null" ? "-" : response)")
                                                .font(.subheadline)
                                        }
                                    }
                                }
                            )
                        }
                        .listStyle(GroupedListStyle())
                    }
                }
            }
            .navigationBarTitle("Your Applications")
            .onAppear {
                isLoading = true
                applicationManager.loadOwnApplications(iteration: 0) {
                    isLoading = false
                }
            }
        }
    }

    private func getStatusColor(status: String) -> Color {
        switch status {
        case "-1": return Color("AlertColor")
        case "0": return Color("FgColor")
        case "1": return Color("SuccessColor")
        default: return Color.primary
        }
    }
    
    private func getStatusText(status: String) -> String {
        switch status {
        case "-1": return "Application has been rejected."
        case "0": return "Application pending."
        case "1": return "Application has been accepted."
        default: return "No information available"
        }
    }

    struct OwnApplicationsView_Previews: PreviewProvider {
        static var previews: some View {
            let errorHandlingManager = ErrorHandlingManager()
            let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
            let jobManager = JobManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)
            let applicationManager = ApplicationManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)

            return OwnApplicationsView()
                .environmentObject(errorHandlingManager)
                .environmentObject(authenticationManager)
                .environmentObject(jobManager)
                .environmentObject(applicationManager)
        }
    }
}
