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
                    URLImage(URL(string: "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fcdn.mos.cms.futurecdn.net%2FohsXtgy8Hmi9PzDNpKhJ5N.jpg&f=1&nofb=1&ipt=beff85e7700e681bbd30275f2a734143240c7d6985562849a485a831fabf0628&ipo=images")!) { image in
                        image
                            .resizable(resizingMode: .tile)
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 200)
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

                    
                    Text("- 2h 30min")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                }
                .border(Color("FgColor"), width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .frame(width: UIScreen.main.bounds.width - 40, height: 200)
                .padding(.horizontal, 20)
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding(.horizontal)
            Spacer()
        }
    }
}

struct Previews_JobCard_Previews: PreviewProvider {
    static var previews: some View {
        JobCardView(job: JobModel.generateRandomJob())
    }
}
