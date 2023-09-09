//
//  AccountView.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State var isLoadingUpcomingJobs = false
    @State var isLoadingNearbyJobs = false

    @State private var notifications: [String] = ["Notification 1", "Notification 2"]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Notifications")
                        .font(.headline)
                    ForEach(notifications, id: \.self) { notification in
                        Text(notification)
                    }
                }

                .padding()
                VStack {
                    Text("Upcoming Jobs")
                        .font(.headline)
                    if isLoadingUpcomingJobs {
                        ProgressView()
                    }
                    if jobManager.upcomingJobs.isEmpty && !isLoadingUpcomingJobs {
                        Text("No confirmed jobs yet.")
                    } else {
                        ForEach(jobManager.upcomingJobs, id: \.jobId) { job in
                            JobCell(job: job)
                        }
                    }
                }
                .padding()

                VStack {
                    Text("Jobs Near You")
                        .font(.headline)
                    if isLoadingNearbyJobs {
                        ProgressView()
                    }
                    if jobManager.nearbyJobs.isEmpty && !isLoadingNearbyJobs {
                        Text("No jobs found.")
                    } else {
                        ForEach(jobManager.nearbyJobs, id: \.jobId) { job in
                            JobCell(job: job)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitle("Start")
        .onAppear {
            // Load notifications, upcoming jobs, and nearby jobs
            // Update 'notifications' and 'nearbyJobs'
            isLoadingUpcomingJobs = true
            jobManager.loadUpcomingJobs(iteration: 0) {
                isLoadingUpcomingJobs = false
            }
            isLoadingNearbyJobs = true
            jobManager.loadNearbyJobs(iteration: 0, longitude: 0.0, latitude: 0.0) {
                isLoadingNearbyJobs = false
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}


struct JobCell: View {
    var job: Job
    
    var body: some View {
        Text("JobCell")
        Text(job.title)
    }
}
