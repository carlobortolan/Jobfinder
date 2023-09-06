//
//  JobListView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation
import SwiftUI
import WebKit


struct JobListView: View {
    @Binding var jobs: [Job]
    
    var body: some View {
        ScrollView {
            ForEach(Array(Set(jobs)), id: \.job_id) { job in
                VStack(spacing: 0) {
                    NavigationLink(destination: JobDetail(job: job)) {
                        JobPreview(job: job)
                            .background(Color("FeedBgColor"))
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.vertical, 8)
                    Divider()
                        .background(Color.gray.opacity(0.5))
                        .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct Previews_JobListView_Previews: PreviewProvider {
    static var previews: some View {
        @State var jobs = JobModel.generateRandomJobResponse().jobs
        JobListView(jobs: $jobs)
    }
}
