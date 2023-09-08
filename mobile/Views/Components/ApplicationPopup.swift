//
//  ApplicationPopup.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct ApplicationPopup: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager
    
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
                                    applicationManager.submitApplication(iteration: 0, jobId: job.jobId, userId: authenticationManager.current.userId, message: message)
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
}
