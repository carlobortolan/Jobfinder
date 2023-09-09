//
//  OwnJobsView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI

struct OwnJobsView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State var isLoading = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Jobs").font(.largeTitle)) {
                    if jobManager.ownJobs.isEmpty && !isLoading {
                        Text("No jobs created yet.")
                    } else {
                        ForEach(jobManager.ownJobs, id: \.jobId) { job in
                            Text(job.title)
                            Text(job.position)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                isLoading = true
                jobManager.loadOwnJobs(iteration: 0) {
                    isLoading = false
                }
            }
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5, anchor: .center)
                    }
                }
            )
        }
    }

    
    struct OwnJobsView_Previews: PreviewProvider {
        static var previews: some View {
            let errorHandlingManager = ErrorHandlingManager()
            let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
            let jobManager = JobManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)
            
            return OwnJobsView()
                .environmentObject(errorHandlingManager)
                .environmentObject(authenticationManager)
                .environmentObject(jobManager)
        }
    }
}
