//
//  AccountInfo.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI
import URLImage

struct AccountInfo: View {
    let user: User
    
    init(user: User) {
        self.user = user
    }

    var body: some View {
        VStack {
            URLImage(URL(string: user.imageUrl)!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            }
            
            Text(user.email)
                .font(.headline)

            Text(user.firstName)
            
            Text(user.lastName)
            
            Spacer()
        }
        .padding()
    }
}
