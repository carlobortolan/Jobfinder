//
//  FilterAndSortView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation
import SwiftUI

struct FilterAndSortView: View {
    @Binding var selectedJobType: String
    @Binding var selectedSortBy: String
    var isLoading: Binding<Bool>
    var onApplyFilters: () -> Void
    
    // TODO: Read job categories from json/api
    let jobCategories: [JobCategory] = [
        JobCategory(label: "All", value: ""),
        JobCategory(label: "Retail", value: "Retail"),
        JobCategory(label: "Food", value: "Food"),
        JobCategory(label: "Hospitality", value: "Hospitality"),
        JobCategory(label: "Tourism", value: "Tourism"),
        JobCategory(label: "Events", value: "Events"),
        JobCategory(label: "Entertainment", value: "Entertainment"),
        JobCategory(label: "Cleaning", value: "Cleaning"),
        JobCategory(label: "Landscaping", value: "Landscaping"),
        JobCategory(label: "Personal_Care", value: "Personal_Care"),
        JobCategory(label: "Childcare", value: "Childcare"),
        JobCategory(label: "Delivery", value: "Delivery"),
        JobCategory(label: "Logistics", value: "Logistics"),
        JobCategory(label: "Transportation", value: "Transportation"),
        JobCategory(label: "Staffing", value: "Staffing"),
        JobCategory(label: "Warehousing", value: "Warehousing"),
        JobCategory(label: "Manufacturing", value: "Manufacturing"),
        JobCategory(label: "Customer_Service", value: "Customer_Service"),
        JobCategory(label: "Call_Centers", value: "Call_Centers"),
        JobCategory(label: "Healthcare", value: "Healthcare"),
        JobCategory(label: "Freelance", value: "Freelance"),
        JobCategory(label: "Construction", value: "Construction"),
        JobCategory(label: "Real_Estate", value: "Real_Estate"),
        JobCategory(label: "Fitness", value: "Fitness"),
        JobCategory(label: "Security", value: "Security"),
        JobCategory(label: "Marketing", value: "Marketing"),
        JobCategory(label: "Sales", value: "Sales"),
        JobCategory(label: "Administration", value: "Administration"),
        JobCategory(label: "IT", value: "IT"),
        JobCategory(label: "Education", value: "Education")
    ]
    
    // TODO: Read sorting options from json/api
    let sortingOptions: [SortOption] = [
        SortOption(label: " Relevance", value: ""),
        SortOption(label: "Salary - High to Low", value: "salary_desc"),
        SortOption(label: "Salary - Low to High", value: "salary_asc"),
        SortOption(label: "Date - Newest First", value: "date_desc"),
        SortOption(label: "Date - Oldest First", value: "date_asc")
    ]
    
    var body: some View {
        HStack {
            Picker("Job Category", selection: $selectedJobType) {
                ForEach(jobCategories, id: \.value) { category in
                    Text(category.label).tag(category.value)
                }
                
            }
            .pickerStyle(MenuPickerStyle())
            
            Picker("Sort By", selection: $selectedSortBy) {
                ForEach(sortingOptions, id: \.value) { option in
                    Text(option.label).tag(option.value)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            Button("Apply") {
                if selectedJobType == "All" {
                    selectedJobType = ""
                }
                isLoading.wrappedValue = true
                onApplyFilters()
            }
        }
        .padding(.horizontal)
    }
}
struct SortOption: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}

struct JobCategory: Identifiable {
    let id = UUID()
    let label: String
    let value: String
}
