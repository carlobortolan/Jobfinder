//
//  SearchBarView.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation
import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    
    @State private var isSearching = false
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchText, onCommit: {
                onSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Image(systemName: "magnifyingglass")
                .scaleEffect(isSearching ? 0.9 : 1.0)
                .onTapGesture {
                    withAnimation {
                        isSearching = true
                        onSearch()
                        
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
