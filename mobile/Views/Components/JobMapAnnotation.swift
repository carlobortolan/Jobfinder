//
//  JobMapAnnotation.swift
//  mobile
//
//  Created by cb on 10.09.23.
//

import SwiftUI

import SwiftUI
import URLImage

struct JobMapAnnotation: View {
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
                JobDetail(job: job)
            }

            Text(job.title)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
}

struct JobMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        JobMapAnnotation(job: JobModel.generateRandomJob())
    }
}