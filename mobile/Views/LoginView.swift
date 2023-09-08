//
//  LoginView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var hasAccount: Bool = false
    @State private var contentHeight: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BgColor")
                    .ignoresSafeArea(.all)
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            if hasAccount {
                                SignInForm(hasAccount: $hasAccount)
                            } else {
                                SignUpForm(hasAccount: $hasAccount)
                            }
                        }
                        .padding()
                        .background(
                            GeometryReader { contentGeometry in
                                Color.clear.preference(key: ViewHeightKey.self, value: contentGeometry.size.height)
                            }
                        )
                    }
                    .frame(minHeight: geometry.size.height)
                    .onPreferenceChange(ViewHeightKey.self) { viewHeight in
                        let screenHeight = UIScreen.main.bounds.height
                        if viewHeight > screenHeight {
                            UIScrollView.appearance().isScrollEnabled = true
                        } else {
                            UIScrollView.appearance().isScrollEnabled = false
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Authentication")
        }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        LoginView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)
    }
}
