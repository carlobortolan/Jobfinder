//
//  JobPrevie.swift
//  mobile
//
//  Created by cb on 05.09.23.
//
//  Describes the job as seen in the feed / search (can be expanded for more details)
//

import Foundation
import SwiftUI
import URLImage

struct JobPreview: View {
    let job: Job
    
    init(job: Job) {
        self.job = job
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Image from URL
            URLImage(URL(string: job.imageUrl)!) { image in
                image
                   .resizable()
                   .aspectRatio(contentMode: .fill)
                   // .frame(width: UIScreen.main.bounds.width, height: 200)
            }
            .cornerRadius(10)
            
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
        }
        .padding()
    }
}

struct JobPreview_Previews: PreviewProvider {
    static var previews: some View {
        let job = JobModel.generateRandomJob()
        return JobPreview(job: job)
    }
}
