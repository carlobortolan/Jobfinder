//
//  AccountView.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import SwiftUI
import MapKit

struct StartView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State var isLoadingUpcomingJobs = false
    @State var isLoadingNearbyJobs = false
    @State private var notifications: [String] = ["Notification 1", "Notification 2"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 325)
                    .foregroundColor(Color("FeedBgColor"))
                    .border(Color("FgColor"), width: 3)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 325)
                            .foregroundColor(Color("FeedBgColor"))
                            .border(Color("FgColor"), width: 3)
                            .padding(.horizontal, 10.0)
                            .overlay(
                                VStack {
                                    Text("Upcoming Jobs")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    if isLoadingUpcomingJobs {
                                        ProgressView()
                                    }
                                    
                                    if jobManager.upcomingJobs.isEmpty && !isLoadingUpcomingJobs {
                                        Text("No confirmed jobs yet.")
                                            .foregroundColor(.secondary)
                                    } else {
                                        JobCarousel().padding()
                                    }
                                    Spacer()
                                }.padding([.top, .leading, .trailing])
                            )
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 300)
                    .foregroundColor(Color("FeedBgColor"))
                    .border(Color("FgColor"), width: 3)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 300)
                            .foregroundColor(Color("FeedBgColor"))
                            .border(Color("FgColor"), width: 3)
                            .padding(.horizontal, 10.0)
                            .overlay(
                                VStack {
                                    Text("Jobs Near You")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                    
                                    if jobManager.nearbyJobs.isEmpty && !isLoadingNearbyJobs {
                                        Text("No jobs found.")
                                            .foregroundColor(.secondary)
                                    } else {
                                        NavigationView {
                                            JobsMapView(nearbyJobs: jobManager.nearbyJobs)
                                        }
                                    }
                                    Spacer()
                                }.padding([.top, .leading, .trailing])
                                    .overlay(
                                        VStack {
                                            if isLoadingNearbyJobs {
                                                Spacer()
                                                ProgressView()
                                                Spacer()
                                            } else {EmptyView()}
                                        })
                            )
                    )
            }
        }
        .navigationBarTitle("EMBLOY", displayMode: .inline)
        .padding()
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

struct NotificationCard: View {
    var notification: String
    
    var body: some View {
        VStack {
            Text(notification)
                .font(.headline)
                .foregroundColor(Color("BgColor"))
                .padding()
                .background(Color("FgColor"))
                .cornerRadius(10)
                .shadow(radius: 3)
        }
    }
}

struct JobCard: View {
    var job: Job
    
    var body: some View {
        VStack {
            Text(job.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("BgColor"))
                .padding()
                .background(Color("FgColor"))
                .cornerRadius(10)
                .shadow(radius: 3)
        }
    }
}
