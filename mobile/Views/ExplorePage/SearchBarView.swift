//
//  SearchBarView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void // Add a callback for search
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit { // Call onSearch when Enter is pressed
                    onSearch()
                }

            Image(systemName: "magnifyingglass")
                .onTapGesture { // Call onSearch when the search icon is tapped
                    onSearch()
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
