//
//  JobCard.swift
//  mobile
//
//  Created by cb on 09.09.23.
//

import SwiftUI
import URLImage

import SwiftUI
import URLImage

struct JobCardView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var isTapped = false
    @State private var isSwiping = false

    var job: Job

    var body: some View {
        Button(action: {}) { ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("FgColor"), lineWidth: 1)
                    .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3.5)
                    .background(
                        URLImage(URL(string: job.imageUrl)!) { image in
                            image
                                .resizable(resizingMode: .tile)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3.5)
                                .cornerRadius(10)
                                .overlay(
                                    VStack(alignment: .center) {
                                        Spacer()
                                        Text("\(job.startSlot)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .multilineTextAlignment(.center)
                                            .padding(.bottom, 5)
                                    }.padding(.horizontal, 20)
                                )
                        }
                    )
                    if let startDate = DateParser.date(from: job.startSlot) {
                        Text("-\(DateParser.timeRemainingCompactString(from: startDate))")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    }
                }
                .frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 3.5)
                .padding(.horizontal, 20)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.horizontal)
                .onLongPressGesture() {
                    isTapped = true
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
        }
    }
}

struct Previews_JobCard_Previews: PreviewProvider {
    static var previews: some View {
        @State var isSwiping = false
        JobCardView(job: JobModel.generateRandomJob())
    }
}
