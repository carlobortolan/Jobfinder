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

    @State private var region: MKCoordinateRegion
    @State private var isApplicationPopupVisible = false
    @State private var isLoading = false
    @State private var applicationMessage = "Write your application message here ..."


    let job: Job

    init(job: Job) {
        self.job = job
        // Create a coordinate region based on the job's latitude and longitude
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: job.latitude, longitude: job.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 350)
                .foregroundColor(Color("FeedBgColor"))
                .border(Color("FgColor"), width: 3)
                .cornerRadius(10)
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .padding(.all)
                    .frame(height: 350)
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
                            Map(coordinateRegion: $region, showsUserLocation: true)
                                .padding()
                        )
                )
                    Button(action: {
                        isApplicationPopupVisible.toggle()
                    }) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 60)
                            .foregroundColor(Color("FeedBgColor"))
                            .border(Color("FgColor"), width: 3)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 60)
                                    .foregroundColor(Color("SuccessColor"))
                                    .border(Color("FgColor"), width: 3)
                                    .padding(.horizontal, 10.0)
                                    .overlay(
                                        Text("APPLY")
                                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                            .fontWeight(.black)
                                            .foregroundColor(Color.white)
                                            .padding()
                                    )
                                    )
                        }
                
            
        }
        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .sheet(isPresented: $isApplicationPopupVisible) {
            NavigationView {
                ApplicationPopup(isVisible: $isApplicationPopupVisible, message: $applicationMessage, job: job)
                    .navigationBarItems(trailing: Button("Close") {
                        isApplicationPopupVisible.toggle()
                    })
                    .navigationBarTitle("\(job.title)", displayMode: .inline)
            }

        }
    }
}

struct JobDetail_Previews: PreviewProvider {
    static var previews: some View {
        let job = JobModel.generateRandomJob()
        return JobDetail(job: job)
    }
}

struct ApplicationPopup: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
   
    @Binding var isVisible: Bool
    @Binding var message: String
    @State private var isLoading = false

    var job: Job
    
    var body: some View {
        ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 350, height: 600)
                    .foregroundColor(Color("FeedBgColor"))
                    .border(Color("FgColor"), width: 3)
                    .cornerRadius(10)
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .padding(.all)
                        .frame(width: 350, height: 600)
                        .foregroundColor(Color("FeedBgColor"))
                        .border(Color("FgColor"), width: 3)
                        .cornerRadius(10)
                        .padding(.horizontal, 10.0)
                        .overlay(
                            VStack {
                                Text("Apply for \(job.position)")
                                    .font(.headline)
                                    .padding([.top, .leading, .trailing])
                                Divider()
                                Text("Enter your application message:")
                                    .font(.subheadline)
                                    .padding([.top, .leading, .trailing])
                                TextEditor(text: $message)
                                    .padding()
                                    .font(.headline)
                                    .border(Color("FgColor"), width: 3)
                                    .padding()
                                    .frame(width: 350, height: 300)

                                Button(action: {
                                    submitApplication(iteration: 0)
                                    isVisible = false
                                }) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("FeedBgColor"))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(Color("SuccessColor"))
                                                .border(Color("FgColor"), width: 3)
                                                .padding(.horizontal, 10.0)
                                                .overlay(
                                                    Text("APPLY")
                                                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                                        .fontWeight(.black)
                                                        .foregroundColor(Color.white)
                                                )
                                                )
                                }
                                .padding()
                                .cornerRadius(10)
                            }
                        )
                    )
        }
    }
    
    func submitApplication(iteration: Int) {
        print("Iteration \(iteration)")
        isLoading = true
        let application = Application(jobId: job.jobId, userId: authenticationManager.current.userId, createdAt: "", updatedAt: "", status: "0", applicationText: message, applicationDocuments: nil, response: nil)
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.createApplication(accessToken: accessToken, application: application) { tokenResponse in
                switch tokenResponse {
                case .success(let apiResponse):
                    DispatchQueue.main.async {
                        print("case .success \(apiResponse)")
                        self.errorHandlingManager.errorMessage = nil
                        isLoading = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("case .failure, iteration: \(iteration)")
                        if iteration == 0 {
                            if case .authenticationError = error {
                                print("case .authenticationError")
                                // Authentication error (e.g., access token invalid)
                                // Refresh the access token and retry the request
                                self.authenticationManager.requestAccessToken() { accessTokenSuccess in
                                    if accessTokenSuccess{
                                        self.submitApplication(iteration: 1)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                    }
                                }
                            } else {
                                print("case .else")
                                // Handle other errors
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                        }
                        isLoading = false
                    }
                }
            }
        }
    }
}
