//
//  ApplicationDetail.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct ApplicationDetail: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @Binding var job: Job
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ApplicationDetail_Previews: PreviewProvider {
    static var previews: some View {
        @State var job = JobModel.generateRandomJob()
        ApplicationDetail(job: $job)
    }
}
