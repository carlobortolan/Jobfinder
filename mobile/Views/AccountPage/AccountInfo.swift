//
//  AccountInfo.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI
import URLImage

struct AccountInfo: View {
    @Binding var user: User
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @State private var isImagePickerPresented = false
    @State private var isImageRemoveAlertPresented = false
    @State private var selectedImage: UIImage?

    var body: some View {
        VStack {
            URLImage(URL(string: user.imageURL ?? "https://embloy.onrender.com/assets/img/features_3.png")!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color("FgColor"), lineWidth: 5)
                    )
                    .onTapGesture {
                        if user.imageURL != nil {
                            // Show the option to remove or upload a new image
                            isImageRemoveAlertPresented.toggle()
                        } else {
                            // Show the image picker to upload a new image
                            isImagePickerPresented.toggle()
                        }
                    }
            }

            .alert(isPresented: $isImageRemoveAlertPresented) {
                Alert(
                    title: Text("Profile Image"),
                    message: Text("Do you want to remove your profile image or upload a new one?"),
                    primaryButton: .destructive(Text("Remove"), action: {
                        // Handle image removal
                        user.imageURL = nil // Set the user's image URL to nil
                        removeUserImage(iteration: 0)
                    }),
                    secondaryButton: .default(Text("Upload New"), action: {
                        // Show the image picker to upload a new image
                        isImagePickerPresented.toggle()
                    })
                )
            }
            // Image Picker
            .sheet(isPresented: $isImagePickerPresented) {
                NavigationView {
                    ImagePickerView(selectedImage: $selectedImage, isImagePickerPresented: $isImagePickerPresented)
                        .navigationBarItems(trailing: Button("Done") {
                            isImagePickerPresented.toggle() // Close the image picker
                        })
                }
            }
            
            Text(user.email)
                .font(.headline)

            Text("\(user.firstName) \(user.lastName)")
            
            HStack {
                Spacer()
                VStack {
                    Text("\(user.viewCount)")
                        .fontWeight(.heavy)
                    Text("\(user.viewCount == 1 ? "View" : "Views")")
                        .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
                VStack {
                    Text("\(user.jobsCount)")
                        .fontWeight(.heavy)
                    Text("\(user.jobsCount == 1 ? "Post" : "Posts")")
                        .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
                VStack {
                    Text("4.8")
                        .fontWeight(.heavy)
                        .fontWeight(.light)
                    Text("Rating")
                        .font(.footnote)
                }
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
    
    func removeUserImage(iteration: Int) {
        print("Iteration \(iteration)")
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.removeUserImage(accessToken: accessToken) { result in
                switch result {
                case .success(let apiResponse):
                    DispatchQueue.main.async {
                        print("case .success \(apiResponse)")
                        self.errorHandlingManager.errorMessage = nil
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
                                        self.removeUserImage(iteration: 1)
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
                    }
                }
            }
        }
    }

}



struct Previews_AccountInfo_Previews: PreviewProvider {
    static var previews: some View {
        @State var user = User.generateRandomUser()
        AccountInfo(user: $user)
    }
}
