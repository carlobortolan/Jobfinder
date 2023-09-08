//
//  AppInfoView.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        VStack {
            Text("About App")
                .font(.largeTitle)
                .padding()
            
            Spacer()
            
            Text("Stay tuned!")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("Version: 1.0")
                .font(.body)
                .padding(.bottom)
            
            Spacer()
        }
    }
}
struct AppInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AppInfoView()
    }
}
