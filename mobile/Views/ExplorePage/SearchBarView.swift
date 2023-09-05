//
//  SearchBarView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.vertical, 8)
        }
        .padding(.horizontal)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        @State var searchText = "ABC"
        SearchBarView(searchText: $searchText)
    }
}
