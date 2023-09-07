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
            URLImage(URL(string: user.imageURL ?? "https://embloy.onrender.com/assets/img/features_3.png")!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color("FgColor"), lineWidth: 5)
                    )
            }
            
            Text(user.email)
                .font(.headline)

            Text("\(user.firstName) \(user.lastName)")
            
            HStack {
                Spacer()
                VStack {
                    Text("123")
                        .fontWeight(.heavy)
                    Text("Follower")
                        .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
                VStack {
                    Text("Level 3")
                        .fontWeight(.heavy)
                    Text("Experience")
                        .font(.footnote)
                        .fontWeight(.light)
                }
                Spacer()
                VStack {
                    Text("4.8")
                        .fontWeight(.heavy)
                        .fontWeight(.light)
                    Text("Rating")
                        .font(.footnote)
                }
                Spacer()
            }
            
            
            Spacer()
        }
        .padding()
        
    }
}

struct Previews_AccountInfo_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfo(user: User.generateRandomUser())
    }
}
