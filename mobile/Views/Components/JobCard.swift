//
//  JobCard.swift
//  mobile
//
//  Created by cb on 09.09.23.
//

import SwiftUI
import URLImage

struct JobCardView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    var job: Job

    var body: some View {
        NavigationLink(destination: JobDetail(job: job)) {
                ZStack(alignment: .center) {
            URLImage(URL(string: job.imageUrl)!) { image in
                image
                    .resizable(resizingMode: .tile)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 200)
                    .cornerRadius(10)
                    .overlay(
                        VStack(alignment: .center) {
                            Spacer()
                            Text("Start Time: \(job.startSlot)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 5)
                        }
                    )
            }
            .padding()
            Text("- 2h 30min")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            Spacer()
            }
        Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 200)
        .padding(.horizontal, 20)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding()
    }
}

struct Previews_JobCard_Previews: PreviewProvider {
    static var previews: some View {
        JobCardView(job: JobModel.generateRandomJob())
    }
}
