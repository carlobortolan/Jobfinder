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
    @State var cvFormat: String?
    @State var fileName: String = ""
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
                                                    .foregroundColor(Color("SecondaryColor"))
                                                    .border(Color("FgColor"), width: 3)
                                                    .padding(.horizontal, 10.0)
                                                    .overlay(
                                                        Text(fileName == "" ? "UPLOAD CV \(job.allowedCvFormat.joined(separator: ", "))" : fileName)
                                                            .font(.headline)
                                                            .fontWeight(.black)
                                                            .foregroundColor(Color.white)
                                                    )
                                            )
                                    }
                                    .padding()
                                    .cornerRadius(10)
                                    .fileImporter(isPresented: $isPickingDocument, allowedContentTypes: FileFormatter.toUTType(allowedCvFormat: job.allowedCvFormat), onCompletion: handleDocumentSelection)
                                }

                                
                                Button(action: {
                                    isLoading = true
                                    DispatchQueue.main.async {
                                        applicationManager.submitApplication(iteration: 0, jobId: job.jobId, userId: authenticationManager.current.userId, message: message, cv: cvData, format: cvFormat) {
                                            isLoading = false
                                            isVisible = false
                                        }
                                    }
                                }) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("FeedBgColor"))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(cvData != nil || !job.cvRequired ? Color("SuccessColor") : Color.gray)
                                                .border(Color("FgColor"), width: 3)
                                                .padding(.horizontal, 10.0)
                                                .overlay(
                                                    Text("APPLY")
                                                        .font(.title)
                                                        .fontWeight(.black)
                                                        .foregroundColor(Color.white)
                                                )
                                        )
                                }
                                .padding()
                                .cornerRadius(10)
                                .disabled(cvData == nil && job.cvRequired)
                            }
                        )
                )
        }
    }
    
    func handleDocumentSelection(result: Result<URL, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let selectedURL):
                do {
                    cvData = try Data(contentsOf: selectedURL)
                    let fileExtension = selectedURL.pathExtension.lowercased()
                        switch fileExtension {
                        case "pdf":
                            cvFormat = ".pdf"
                        case "doc", "docx":
                            cvFormat = ".docx"
                        case "xml":
                            cvFormat = ".xml"
                        case "txt":
                            cvFormat = ".txt"
                        default:
                            cvFormat = "unknown"
                        }
                    print("CVFORMAT EXTENSION: \(String(describing: cvFormat))")
                } catch {
                    print("Error reading file data: \(error)")
                }
                fileName = selectedURL.lastPathComponent
            case .failure(let error):
                print("File Selection Error: \(error.localizedDescription)")
            }
        }
    }
}
