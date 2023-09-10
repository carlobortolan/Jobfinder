//
//  SwiftUIView.swift
//  mobile
//
//  Created by cb on 10.09.23.
//

import SwiftUI

struct ContactAndDirections: View {
    let job: Job

    var body: some View {
        HStack {
            if let phone = job.employerPhone {
                Spacer()
                Link(destination: URL(string: "tel://\(phone)")!) {
                    Image(systemName: "phone")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                Spacer()
            }

            if let email = job.employerEmail {
                Spacer()
                Link(destination: URL(string: "mailto:\(email)")!) {
                    Image(systemName: "envelope")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            Spacer()
            Link(destination: getDirectionsURL()) {
                Image(systemName: "arrow.right.circle")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            Spacer()
        }.padding()
    }

    // Function to generate directions URL
    private func getDirectionsURL() -> URL {
        let destinationLat = job.latitude
        let destinationLong = job.longitude
        let googleMapsURL = "https://www.google.com/maps/dir/?api=1&destination=\(destinationLat),\(destinationLong)"
        
        return URL(string: googleMapsURL)!
    }
}

struct Previews_ContactAndDirections_Previews: PreviewProvider {
    static var previews: some View {
        ContactAndDirections(job: JobModel.generateRandomJob())
    }
}
