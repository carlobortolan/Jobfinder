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
    @State var cvData: Data?
    @State private var isLoading = false
    @State private var isPickingDocument = false
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
                                
                                if job.cvRequired {
                                    Button(action: {
                                        isPickingDocument.toggle()
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
                                                        Text("UPLOAD CV [\(String(describing: job.allowedCvFormat))]")
                                                            .font(.headline)
                                                            .fontWeight(.black)
                                                            .foregroundColor(Color.white)
                                                    )
                                            )
                                    }
                                    .padding()
                                    .cornerRadius(10)
                                    .fileImporter(isPresented: $isPickingDocument, allowedContentTypes: [.pdf], onCompletion: handleDocumentSelection)
                                }

                                
                                Button(action: {
                                    applicationManager.submitApplication(iteration: 0, jobId: job.jobId, userId: authenticationManager.current.userId, message: message, cv: cvData)
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
    
    private func handleDocumentSelection(result: Result<URL, Error>) {
        if case .success(let url) = result {
            do {
                cvData = try Data(contentsOf: url)
            } catch {
                // Handle error while reading file data
                print("Error reading file data: \(error)")
            }
        } else if case .failure(let error) = result {
            // Handle document picker error
            print("Document picker error: \(error)")
        }
    }
}
