//
//  JobMapAnnotation.swift
//  mobile
//
//  Created by cb on 10.09.23.
//

import SwiftUI
import URLImage

import SwiftUI
import URLImage

struct ConeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: 4*rect.maxY)) // Start from the center bottom
        path.addLine(to: CGPoint(x: rect.maxX - 4.0, y: rect.minY)) // Go to the top-right
        path.addLine(to: CGPoint(x: rect.minX + 4.0, y: rect.minY)) // Go to the top-left
        path.closeSubpath() // Close the path

        return path
    }
}

struct JobMapAnnotation: View {
    let job: Job

    var body: some View {
        ZStack {
            VStack {
                URLImage(URL(string: job.imageUrl)!) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 40, height: 40)
                )
            }
            .zIndex(1) // Place the image circle above other elements

            ZStack {
                ConeShape()
                    .fill(Color.black) // Cone fill color (white)
                    .frame(width: 40, height: 12)
                    .offset(y: 17) // Adjust the offset as needed
                ConeShape()
                    .stroke(Color.white, lineWidth: 2) // Cone border color (black)
                    .frame(width: 40, height: 12)
                    .offset(y: 17) // Adjust the offset as needed
            }
            .zIndex(0) // Place the cone behind the image circle
        }
        .overlay(
            ZStack {
                Ellipse()
                    .fill(Color.black)
                    .frame(width: 40, height: 12)
                    .offset(y: 60)
                    .frame(width: 36, height: 36)
                Ellipse()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 40, height: 12)
                    .offset(y: 60)
            }
        )
    }
}

struct JobMapAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        JobMapAnnotation(job: JobModel.generateRandomJob())
    }
}
