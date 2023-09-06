//
//  JobPrevie.swift
//  mobile
//
//  Created by cb on 05.09.23.
//
//  Describes the job as seen in the feed / search (can be expanded for more details)
//

import SwiftUI
import MapKit

struct JobPreview: View {
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
            Text(job.title)
                .font(.headline)

            // TODO: Figure out size
            // HTMLView(htmlString: job.description.body, fontSize: 18)

            Text("Job Type: \(job.job_type)")
                .font(.subheadline)

            Text("Location: \(job.city), \(job.country_code)")
                .font(.subheadline)

            Text("Salary: \(job.salary) \(job.currency)")
                .font(.subheadline)

            Text("Duration: \(job.duration) months")
                .font(.subheadline)
           
            Map(coordinateRegion: $region, showsUserLocation: true)
                .frame(height: 200)
                
            Spacer()
        }
        .padding()
    }
}
