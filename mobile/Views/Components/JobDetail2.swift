//
//  JobDetail.swift
//  mobile
//
//  Created by cb on 06.09.23.
//  Describes the job as seen in the feed / search when expanded for more details
//

import SwiftUI
import MapKit

struct JobDetail2: View {
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
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FgColor"), lineWidth: 5)
                    .frame(height: 60)
                    .foregroundColor(Color("FeedBgColor"))
                    .border(Color("FgColor"), width: 3)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .foregroundColor(Color("FeedBgColor"))
                            .border(Color("FgColor"), width: 3)
                            .padding(.horizontal, 10.0)
                            .overlay(
                                VStack{
                                    Text(job.title)
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("FgColor"))
                                        .padding()
                                }
                            )
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FgColor"), lineWidth: 5)
                    .frame(height: 70)
                    .border(Color("FgColor"), width: 3)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 70)
                            .foregroundColor(Color("NoticeColor"))
                            .border(Color("FgColor"), width: 3)
                            .padding(.horizontal, 10.0)
                            .overlay(
                                VStack{
                                    if let startDate = DateParser.date(from: job.startSlot) {
                                        Text("-\(DateParser.timeRemainingCompactString(from: startDate))")
                                            .font(.title)
                                            .fontWeight(.black)
                                            .foregroundColor(Color.white)
                                    }
                                }
                            )
                    )
                    
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FgColor"), lineWidth: 5)
                    .frame(height: 200)
                    .foregroundColor(Color("FeedBgColor"))
                    .border(Color("FgColor"), width: 3)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.all)
                            .frame(height: 200)
                            .foregroundColor(Color("FeedBgColor"))
                            .border(Color("FgColor"), width: 3)
                            .padding(.horizontal, 10.0)
                            .overlay(
                                VStack(alignment: .center, spacing: 10) {
                                    HStack(alignment: .center) {
                                        VStack(alignment: .leading) {
                                            Text("Employer:")
                                                .font(.subheadline)
                                                .fontWeight(.light)
                                            Text(job.employerName ?? "n.a.")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                        }
                                        Divider()
                                            .background(Color("FgColor"))
                                            .padding(.horizontal, 10)
                                        VStack(alignment: .center) {
                                            HStack {
                                                CustomRating(rating: Double(job.employerRating))
                                                Text("(51)")
                                                    .font(.caption2)
                                                    .fontWeight(.light)
                                                    .multilineTextAlignment(.center)
                                            }
                                            Text("82%")
                                                .font(.title2)
                                                .fontWeight(.medium)
                                                .multilineTextAlignment(.center)
                                            Text("would work here again")
                                                .font(.caption2)
                                                .fontWeight(.light)
                                                .multilineTextAlignment(.center)
                                        }
                                    }.padding()
                                    Divider()                                            .background(Color("FgColor"))
                                    HStack() {
                                        Image(systemName: "calendar.circle")
                                            .foregroundColor(Color("FgColor"))
                                            .font(.system(size: 30))
                                        if let date = DateParser.parseDate(job.startSlot) {
                                            Text(DateParser.formatDate(date: date))
                                        } else {
                                            Text("Invalid Date Format")
                                        }
                                    }.padding([.horizontal, .bottom])
                                }.foregroundColor(Color("FgColor"))
                            )
                    )
                                        
                                        
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FgColor"), lineWidth: 5)
                    .frame(height: 410)
                    .foregroundColor(Color("FeedBgColor"))
                    .border(Color("FgColor"), width: 3)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .padding(.all)
                            .frame(height: 410)
                            .foregroundColor(Color("FeedBgColor"))
                            .border(Color("FgColor"), width: 3)
                            .padding(.horizontal, 10.0)
                            .overlay(
                                VStack(alignment: .leading) {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Group {
                                            Text("About the job")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            Text("Job Type: \(job.jobType)")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .padding(.horizontal)
                                            Text("Salary: \(job.salary) \(job.currency) for \(job.duration) h")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .padding(.horizontal)
                                            Text("Duration: \(job.duration) months")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .padding(.horizontal)
                                        }.padding(.horizontal)
                                    }.padding(.horizontal)
                                    Divider()
                                        .background(Color("FgColor"))
                                    VStack(alignment: .leading, spacing: 10) {
                                        Group {
                                            Text("About you")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            Text("Position: \(job.position)")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .padding(.horizontal)
                                            Text("Key skills: \(job.keySkills)")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .padding(.horizontal)
                                        }.padding(.horizontal)
                                    }.padding(.horizontal)
                                    Divider()
                                        .background(Color("FgColor"))
                                    VStack(alignment: .leading, spacing: 10) {
                                        Group {
                                            Text("Location")
                                                .font(.title3)
                                                .fontWeight(.semibold)
                                            Text("\(job.city), \(job.countryCode), \(job.postalCode) ,\(job.address)")
                                                .font(.headline)
                                                .fontWeight(.medium)
                                                .padding(.horizontal)
                                            ContactAndDirections(job: job)
                                        }.padding(.horizontal)
                                    }.padding(.horizontal)
                                }.foregroundColor(Color("FgColor"))
                            )
                    )
                

                
                    
                    
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FgColor"), lineWidth: 5)
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
                    }
                }
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
                    ApplicationDetail(jobId: job.jobId).foregroundColor(Color("FgColor"))
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



struct JobDetail2_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        let jobManager = JobManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)
        let applicationManager = ApplicationManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)

        let job = JobModel.generateRandomJob()
        return JobDetail2(job: job).environmentObject(errorHandlingManager).environmentObject(authenticationManager).environmentObject(jobManager).environmentObject(applicationManager)
    }
}
