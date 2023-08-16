//
//  SwiftUIView.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            StartView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            FeedView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Feed")
                }
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
        }
    }
}
struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
