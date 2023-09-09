//
//  JobCarouselView.swift
//  mobile
//
//  Created by cb on 09.09.23.
//

import SwiftUI

struct JobCarousel: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(jobManager.upcomingJobs.indices, id: \.self) { index in
                    JobCardView(job: jobManager.upcomingJobs[index])
                        .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                        .padding(.horizontal, 20)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 300)
            .padding(.top, 10)
        }
        .padding()
    }
}

struct Previews_JobCarusel_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        let jobManager = JobManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)
        return JobCarousel()
            .environmentObject(jobManager)
    }}
