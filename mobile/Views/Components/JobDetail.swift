//
//  JobDetail.swift
//  mobile
//
//  Created by cb on 06.09.23.
//  Describes the job as seen in the feed / search when expanded for more details
//

import SwiftUI
import MapKit

struct JobDetail: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var isApplicationPopupVisible = false
    @State private var isLoading = false
    @State private var hasApplication = false
    @State private var applicationMessage = "Write your application message here ..."
    @State var job: Job
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 300)
                .foregroundColor(Color("FeedBgColor"))
                .border(Color("FgColor"), width: 3)
                .cornerRadius(10)
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .padding(.all)
                    .frame(height: 300)
                    .foregroundColor(Color("FeedBgColor"))
                    .border(Color("FgColor"), width: 3)
                    .padding(.horizontal, 10.0)
                    .overlay(
                        VStack(alignment: .center, spacing: 10) {
                            Text(job.title)
                                .font(.title)
                                .padding(.horizontal)
                            Divider()
                                .padding()

                            Text("Job Type: \(job.jobType)")
                                .font(.title3)
                                .padding(.horizontal)
                            
                            Text("Salary: \(job.salary) \(job.currency) for \(job.duration) h")
                                .font(.title3)
                                .padding(.horizontal)
                            
                            Text("Duration: \(job.duration) months")
                                .font(.title3)
                                .padding(.horizontal)
                            Divider()
                                .padding()

                            Text("Location: \(job.city), \(job.countryCode)")
                                .font(.subheadline)
                                .padding(.horizontal)
                        }
                    )
                )
            
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 200)
                .foregroundColor(Color("FeedBgColor"))
                .border(Color("FgColor"), width: 3)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 200)
                        .foregroundColor(Color("FeedBgColor"))
                        .border(Color("FgColor"), width: 3)
                        .padding(.horizontal, 10.0)
                        .overlay(
                            JobMapView(job: job).padding()
                        )
                )
                Button(action: {
                    isApplicationPopupVisible.toggle()
                }) {
                    if hasApplication {
                        OwnApplicationButton()
                    } else {
                        ApplicationButton()
                    }
                }
            }
            .onAppear() {
                hasApplication = applicationManager.hasApplication(forUserId:
                                                                authenticationManager.current.userId, andJobId: job.jobId)
            }
            .padding()
            .sheet(isPresented: $isApplicationPopupVisible) {
                if hasApplication {
                    ApplicationDetail(jobId: job.jobId)
                } else {
                    NavigationView {
                        ApplicationPopup(isVisible: $isApplicationPopupVisible, message: $applicationMessage, job: job)
                            .navigationBarItems(trailing: Button("Close") {
                                isApplicationPopupVisible.toggle()
                            })
                            .navigationBarTitle("\(job.title)", displayMode: .inline)
                    }
                    .onDisappear {
                        hasApplication = applicationManager.hasApplication(forUserId: authenticationManager.current.userId, andJobId: job.jobId)
                        print("Sheet disappeared - test")
                    }
                }
            }
    }
}



struct JobDetail_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        let jobManager = JobManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)
        let applicationManager = ApplicationManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)

        let job = JobModel.generateRandomJob()
        return JobDetail(job: job).environmentObject(errorHandlingManager).environmentObject(authenticationManager).environmentObject(jobManager).environmentObject(applicationManager)
    }
}

