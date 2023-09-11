//
//  CustomRating.swift
//  mobile
//
//  Created by cb on 11.09.23.
//

import SwiftUI

struct CustomRating: View {
    var rating: Double

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5) { index in
                ZStack {
                    Circle()
                        .frame(width: 16, height: 16)
                        .foregroundColor(index < Int(rating) ? Color("WarningColor") : Color.gray.opacity(0.25))
                        .overlay(
                            Circle()
                                .stroke(Color("FgColor"), lineWidth: 2)
                        )
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(Color("FgColor"))
                        .padding(1)
                }
            }
        }
    }
}

struct CustomRating_Previews: PreviewProvider {
    static var previews: some View {
        CustomRating(rating: 4.3)
    }
}
