//
//  AccountInfo.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI
import URLImage

struct AccountInfo: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager
    
    @State private var isImagePickerViewPresented = false
    @State private var isImageRemoveAlertPresented = false

    var body: some View {
        VStack {
            Group() {
                if (authenticationManager.current.imageURL != nil) {
                    URLImage(URL(string: authenticationManager.current.imageURL ?? "https://embloy.onrender.com/assets/img/features_3.png")!) { image in
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
                                if authenticationManager.current.imageURL != nil {
                                    isImageRemoveAlertPresented.toggle()
                                } else {
                                    isImagePickerViewPresented.toggle()
                                }
                            }
                    }
                } else {
                    Image("ProfilePlaceholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color("FgColor"), lineWidth: 5)
                        )
                        .onTapGesture {
                            if authenticationManager.current.imageURL != nil {
                                // Show the option to remove or upload a new image
                                isImageRemoveAlertPresented.toggle()
                            } else {
                                // Show the image picker to upload a new image
                                isImagePickerViewPresented.toggle()
                            }
                        }
                }
            }
            
            .alert(isPresented: $isImageRemoveAlertPresented) {
                Alert(
                    title: Text("Profile Image"),
                    message: Text("Do you want to remove your profile image or upload a new one?"),
                    primaryButton: .destructive(Text("Remove"), action: {
                        // Handle image removal
                        authenticationManager.current.imageURL = nil
                        authenticationManager.removeUserImage(iteration: 0) {
                        }
                    }),
                    secondaryButton: .default(Text("Upload New"), action: {
                        isImagePickerViewPresented.toggle()
                    })
                )
            }
            // Image Picker
            .sheet(isPresented: $isImagePickerViewPresented) {
                NavigationView {
                    ImagePickerView(isImagePickerViewPresented: $isImagePickerViewPresented)
                        .navigationBarItems(trailing: Button("Close") {
                            isImagePickerViewPresented.toggle()
                        })
                }
            }
            
            Text(authenticationManager.current.email)
                .font(.headline)

            Text("\(authenticationManager.current.firstName) \(authenticationManager.current.lastName)")
            
            HStack {
                Spacer()
                VStack {
                    Text("\(authenticationManager.current.viewCount)")
                        .fontWeight(.heavy)
                    Text("\(authenticationManager.current.viewCount == 1 ? "View" : "Views")")
                        .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
                VStack {
                    Text("\(authenticationManager.current.jobsCount)")
                        .fontWeight(.heavy)
                    Text("\(authenticationManager.current.jobsCount == 1 ? "Post" : "Posts")")
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
}



struct Previews_AccountInfo_Previews: PreviewProvider {
    static var previews: some View {
        @State var user = User.generateRandomUser()
        AccountInfo()
    }
}
