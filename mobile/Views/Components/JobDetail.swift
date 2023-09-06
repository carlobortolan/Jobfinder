//
//  JobDetail.swift
//  mobile
//
//  Created by cb on 06.09.23.
//  Describes the job as seen in the feed / search when expanded for more details
//

import Foundation
import SwiftUI
import MapKit
import URLImage

struct JobDetail: View {
    let job: Job
    @State private var region: MKCoordinateRegion
    
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
            // Use URLImage to load and display the remote image
            URLImage(URL(string: job.imageUrl)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.frame(height: 200)
            }
            
            Text(job.title)
                .font(.headline)

            Text("Job Type: \(job.jobType)")
                .font(.subheadline)

            Text("Location: \(job.city), \(job.countryCode)")
                .font(.subheadline)

            Text("Salary: \(job.salary) \(job.currency)")
                .font(.subheadline)

            Text("Duration: \(job.duration) months")
                .font(.subheadline)
           
            Map(coordinateRegion: $region, showsUserLocation: true)
                .frame(height: 200)
        }
        .padding()
    }
}

struct JobDetail_Previews: PreviewProvider {
    static var previews: some View {
        let job = JobModel.generateRandomJob()
        return JobDetail(job: job)
    }
}
