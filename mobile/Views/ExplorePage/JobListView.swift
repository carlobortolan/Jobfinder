//
//  JobListView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI
import WebKit

struct JobListView: View {
    @Binding var jobs: [Job]

    var body: some View {
        List(jobs, id: \.job_id) { job in
            NavigationLink(destination: JobPreview(job: job)) {
                Text(job.title)
                    .font(.headline)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

