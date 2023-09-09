//
//  ProfileView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var isLoading = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Description:")
                    .font(.headline)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                Text("\"Hey, I'm \(authenticationManager.current.firstName) \(authenticationManager.current.lastName)\"")
                    .font(.body)
                    .multilineTextAlignment(.leading)

                HStack {
                    Text("From:")
                        .font(.headline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text("\(authenticationManager.current.city ?? "n.a."), \(authenticationManager.current.countryCode ?? "n.a.")")
                        .font(.body)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Born:")
                        .font(.headline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text(
                        formatDate(
                            dateString: DateFormattedISO8601.dateFormatter.string(
                                for: authenticationManager.current.dateOfBirth) ?? ""
                        ) ?? "n.a."
                    )
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Member since:")
                        .font(.headline)
                        .fontWeight(.light)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text(formatDate(dateString: authenticationManager.current.createdAt) ?? "n.a.")
                        .font(.body)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("Email:")
                        .font(.headline)
                        .fontWeight(.light)
                    Spacer()
                    if let mailtoURL = URL(string: "mailto:\(authenticationManager.current.email)") {
                        Link(destination: mailtoURL, label: {
                            Text(authenticationManager.current.email)
                                .fontWeight(.bold)
                        })
                    }
                }

                // TODO: Add personal website
                HStack {
                    Text("Website:")
                        .font(.headline)
                        .fontWeight(.light)
                    Spacer()
                    if let websiteURL = URL(string: "https://about.embloy.com"),
                       let websiteName = getWebsiteName(from: websiteURL.absoluteString) {
                        Link(destination: websiteURL, label: {
                            Text(websiteName)
                                .fontWeight(.bold)
                        })
                    }
                }
                
                HStack {
                    Text("Account Status:")
                        .font(.headline)
                        .fontWeight(.light)
                    Spacer()
                    Text(authenticationManager.current.activityStatus == 1 ? "Active" : "Inactive")
                        .font(.body)
                        .fontWeight(.bold)
                }
            }.padding()
            
            HStack(alignment: .center, spacing: 10) {
                if let linkedInURL = authenticationManager.current.linkedinURL {
                    Button(action: {
                        openSocialMediaProfile(urlString: linkedInURL)
                    }) {
                        Image("linkedInIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                }
                
                if let twitterURL = authenticationManager.current.twitterURL {
                    Button(action: {
                        openSocialMediaProfile(urlString: twitterURL)
                    }) {
                        Image("twitterIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                }
                
                if let facebookURL = authenticationManager.current.facebookURL {
                    Button(action: {
                        openSocialMediaProfile(urlString: facebookURL)
                    }) {
                        Image("facebookIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                    }
                }
                
                if let instagramURL = authenticationManager.current.instagramURL {
                    Button(action: {
                        openSocialMediaProfile(urlString: instagramURL)
                    }) {
                        Image("instagramIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.orange)
                    }
                }
            }.padding()
            
            Spacer()
                .frame(maxHeight: .infinity)
        }
        .onAppear {
            isLoading = true
            authenticationManager.loadProfile(iteration: 0) {
                isLoading = false
            }
        }
        .padding()
    }
    func openSocialMediaProfile(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    // TODO: Push to /shared
    private func getWebsiteName(from urlString: String) -> String? {
        if let url = URL(string: urlString) {
            if let host = url.host {
                return host
            }
        }
        return nil
    }
    
    // TODO: Push to /shared
    func formatDate(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
    
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            let errorHandlingManager = ErrorHandlingManager()
            let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
            authenticationManager.current = User.generateRandomUser()
            return ProfileView()
                .environmentObject(errorHandlingManager)
                .environmentObject(authenticationManager)
        }
    }
}
 
