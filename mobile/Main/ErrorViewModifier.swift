//
//  ErrorView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI


struct ErrorViewModifier: ViewModifier {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager

    func body(content: Content) -> some View {
        ZStack {
            content

            if let errorMessage = errorHandlingManager.errorMessage {
                Color(UIColor.black.withAlphaComponent(0.6))
                    .ignoresSafeArea()
                    .onTapGesture {
                        errorHandlingManager.errorMessage = nil
                    }
                VStack {
                    HStack {
                        Text(errorMessage)
                            .foregroundColor(Color("AlertColor"))
                        Spacer()
                        Button(action: {
                            errorHandlingManager.errorMessage = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
                .background(BlurView(style: .systemThinMaterial)) // Add background blur effect
                .cornerRadius(12)
                .padding()
            }
        }
    }
}

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
