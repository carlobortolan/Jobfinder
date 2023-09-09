//
//  JobCarouselView.swift
//  mobile
//
//  Created by cb on 09.09.23.
//

// TODO: Improve scroll animation

import SwiftUI
import Combine

struct JobCarousel: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var currentPage = 0

    var body: some View {
        ZStack {
            ForEach(jobManager.upcomingJobs.indices, id: \.self) { index in
                let scale = getScale(for: index, currentPage: currentPage)
                let offset = getOffset(for: index, currentPage: currentPage)

                JobCardView(job: jobManager.upcomingJobs[index])
                    .frame(width: UIScreen.main.bounds.width - 50, height: 200)
                    .padding(.horizontal, 20)
                    .scaleEffect(scale)
                    .offset(x: offset, y: 0)
                    .zIndex(Double(-abs(currentPage - index)))
                    .animation(.easeInOut)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: 200)
        .onReceive(Just(currentPage)) { page in
            // Update the currentPage whenever the user swipes
            currentPage = page
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < 0 {
                        // Swiped to the left, move to the next page or cycle to the first page
                        if currentPage == jobManager.upcomingJobs.count - 1 {
                            currentPage = 0
                        } else {
                            currentPage = currentPage + 1
                        }
                    } else {
                        // Swiped to the right, move to the previous page or cycle to the last page
                        if currentPage == 0 {
                            currentPage = jobManager.upcomingJobs.count - 1
                        } else {
                            currentPage = currentPage - 1
                        }
                    }
                }
        )
    }

    // Calculate the scale factor based on the position relative to the current page
    private func getScale(for index: Int, currentPage: Int) -> CGFloat {
        let currentIndex = CGFloat(index)
        let scaleFactor: CGFloat = 0.1 // Adjust the scaling factor as needed
        return 1.0 - abs(CGFloat(currentPage) - currentIndex) * scaleFactor
    }

    // Calculate the horizontal offset based on the position relative to the current page
    private func getOffset(for index: Int, currentPage: Int) -> CGFloat {
        let currentIndex = CGFloat(index)
        let offsetFactor: CGFloat = 50 // Adjust the offset factor as needed
        return (currentIndex - CGFloat(currentPage)) * offsetFactor
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
