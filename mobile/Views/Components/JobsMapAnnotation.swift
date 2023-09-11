//
//  JobsMapAnnotation.swift
//  mobile
//
//  Created by cb on 10.09.23.
//

import SwiftUI
import URLImage

struct JobsMapAnnotation: View {
    let job: Job
    @State private var isTapped = false

    var body: some View {
        VStack {
            Button(action: {
                isTapped = true
            }) {
                URLImage(URL(string: job.imageUrl)!) { image in
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }.background(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 36, height: 36)
                )
            }
            .sheet(isPresented: $isTapped) {
                NavigationView {
                    JobDetail2(job: job).background(Color("FeedBgColor"))
                        .navigationBarItems(trailing: Button("Close") {
                            isTapped.toggle()
                        })
                        .navigationBarTitle("Job Details", displayMode: .inline)
                }
            }

            Text(job.title)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
}

struct JobsMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        JobMapAnnotation(job: JobModel.generateRandomJob())
    }
}
