//
//  OwnApplicationButton.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct OwnApplicationButton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(height: 60)
            .foregroundColor(Color("FeedBgColor"))
            .border(Color("FgColor"), width: 3)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 60)
                    .foregroundColor(Color("PrimaryDarkColor"))
                    .border(Color("FgColor"), width: 3)
                    .padding(.horizontal, 10.0)
                    .overlay(
                        Text("SEE APPLICATION")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(Color.white)
                            .padding()
                    )
            )
    }
}

struct OwnApplicationButton_Previews: PreviewProvider {
    static var previews: some View {
        OwnApplicationButton()
    }
}
