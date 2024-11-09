//
//  BuildingDetailView.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct BuildingDetailView: View {
    
    @State private var searchText: String = ""
    
    @State private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
        
    var body: some View {
        NavigationStack {
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: columns) {
                        
                        Text("HELLO")
                    }

                }
            }
            .searchable(text: $searchText, prompt: "Search for lost items")
            .navigationTitle("Franklin dinning hall")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    BuildingDetailView()
}
