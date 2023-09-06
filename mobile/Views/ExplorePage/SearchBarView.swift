//
//  SearchBarView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void // Add a callback for search
    
    @State private var isSearching = false // Track if searching animation is active
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit { // Call onSearch when Enter is pressed
                    onSearch()
                }

            Image(systemName: "magnifyingglass")
                .scaleEffect(isSearching ? 0.9 : 1.0) // Scale down the button when isSearching is true
                .onTapGesture { // Call onSearch when the search icon is tapped
                    withAnimation {
                        isSearching = true // Trigger the animation
                        onSearch()
                        
                        // Reset the animation after a short delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isSearching = false
                        }
                    }
                }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        @State var searchText = "ABC"
        SearchBarView(searchText: $searchText) {
            print("")
        }
    }
}
