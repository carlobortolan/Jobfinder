//
//  ContentView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color("BgColor").edgesIgnoringSafeArea(.all)
            
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(Color("PrimaryColor"))
                Text("Hello, world!")
            }
            .padding()
            .background(Color("BgColor"))
            .foregroundColor(Color("FgColor"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
