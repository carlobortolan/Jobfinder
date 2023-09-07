//
//  ImagePickerView.swift
//  mobile
//
//  Created by cb on 07.09.23.
//

import SwiftUI

struct ImagePickerView: View {
    @Binding var selectedImage: UIImage?
    @Binding var isImagePickerPresented: Bool

    var body: some View {
        VStack {
            Text("Select Profile Image")
                .font(.title)
                .padding()

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
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

            Spacer()
        }
    }
}
