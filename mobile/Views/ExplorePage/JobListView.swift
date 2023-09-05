//
//  JobListView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI

struct JobListView: View {
    @Binding var jobs: [Job]

    var body: some View {
        List(jobs, id: \.jobId) { job in
            VStack(alignment: .leading) {
                Text(job.title)
                    .font(.headline)
                Text(job.description.body)
                    .font(.subheadline)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        @State var result = [Job.init(jobId: 2, jobType: "Abc", jobTypeValue: 123, jobStatus: 123, status: "public", userId: 5, duration: 123, codeLang: "DE", title: "Title", position: "Position", description: Job.Description(id: 1, name: "Description", body: "DescriptionBody", recordType: "RecordType", recordId: 5, createdAt: "12.02.2021", updatedAt: "12.02.2021"), keySkills: "Tennis", salary: 35841.32, euroSalary: 245.325, relevanceScore: 12, currency: "EUR", startSlot: "12.02.2021", longitude: 131, latitude: 1358, countryCode: "DE", postalCode: "80805", city: "Munich", address: "Heimstättenstraße 6", viewCount: 631, createdAt: "12.02.2021", updatedAt: "12.02.2021", applicationsCount: 63, employerRating: 4.3, jobNotifications: "0", boost: 42, cvRequired: false, jobValue: "135131", allowedCvFormat: [".pdf", ".docx"], imageUrl: "https://embloy.com/logo")]
        JobListView(jobs: $result)
    }
}
