//
//  ImagePickerView.swift
//  mobile
//
//  Created by cb on 07.09.23.
//

import SwiftUI

struct ImagePickerView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager
    
    @State private var isLoading = false
    @State var selectedImage: UIImage?
    @State var isImagePickerPresented = false


    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            }
            Text("Select profile Image")
                .font(.title)
                .padding()

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Text("No Image Selected")
                    .font(.headline)
            }

            Button("Select Image") {
                isImagePickerPresented.toggle()
            }
            .padding()

            Button("Remove Image") {
                selectedImage = nil
                isImagePickerPresented = false // Close the image picker after removing the image
            }
            .padding()
            .disabled(selectedImage == nil)

            Button("Upload Image") {
                if let image = selectedImage {
                    isLoading = true
                    DispatchQueue.main.async {
                        authenticationManager.uploadUserImage(iteration: 0, image: image) {
                            isLoading = false
                        }
                    }
                }
            }
            .padding()
            .disabled(selectedImage == nil)

            Spacer()
        }
        .sheet(isPresented: $isImagePickerPresented) {
            // Use the ImagePicker here to handle image selection
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}
