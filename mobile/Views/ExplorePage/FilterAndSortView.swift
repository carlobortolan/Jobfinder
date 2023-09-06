//
//  FilterAndSortView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation
import SwiftUI

import SwiftUI

struct FilterAndSortView: View {
    @Binding var selectedJobType: String
    @Binding var selectedSortBy: String
    var onApplyFilters: () -> Void
    
    // Define job categories
    let jobCategories: [String] = [
        "All", "Retail", "Food", "Hospitality", "Tourism", "Events", "Entertainment",
        "Cleaning", "Landscaping", "Personal_Care", "Childcare", "Delivery", "Logistics",
        "Transportation", "Staffing", "Warehousing", "Manufacturing", "Customer_Service",
        "Call_Centers", "Healthcare", "Freelance", "Construction", "Real_Estate",
        "Fitness", "Security", "Marketing", "Sales", "Administration", "IT", "Education"
    ]
    
    // Define sorting options
    let sortingOptions: [SortOption] = [
        SortOption(label: " Relevance", value: ""),
        SortOption(label: "Salary - High to Low", value: "salary_desc"),
        SortOption(label: "Salary - Low to High", value: "salary_asc"),
        SortOption(label: "Date - Newest First", value: "date_desc"),
        SortOption(label: "Date - Oldest First", value: "date_asc")
        // Add more sorting options as needed
    ]
    
    var body: some View {
        HStack {
            // Job Category Filter
            Picker("Job Category", selection: $selectedJobType) {
                ForEach(jobCategories, id: \.self) { category in
                    Text(category).tag(category)
                }
                
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Sort By", selection: $selectedSortBy) {
                ForEach(sortingOptions, id: \.value) { option in
                    Text(option.label)
                        .tag(option.value)
                }
            }
            .pickerStyle(DefaultPickerStyle())
            
            Button("Apply") {
                if selectedJobType == "All" {
                    selectedJobType = ""
                }

                onApplyFilters()
            }
        }
        .padding()
    }
}

struct SortOption: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}
