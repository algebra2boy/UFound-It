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
        GridItem(.flexible())
    ]
    
    let data = (1...20).map { "Item \($0)" }
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        ForEach(data, id: \.self) { item in
                            
                            VStack(alignment: .leading) {
                                
                                
                                asyncUrlImage(url: "https://upload.wikimedia.org/wikipedia/commons/a/a2/Yellow_Transparent_%28cropped%29.jpg")
                                    .frame(height: 100)
                                Text(item)
                                    .padding(.horizontal)
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                    .padding()
                }
            }
            
            .searchable(text: $searchText, prompt: "Search for lost items")
            .navigationTitle("Franklin dinning hall")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    
    
    @ViewBuilder
    func asyncUrlImage(url: String) -> some View {
        if let url = URL(string: url) {
            AsyncImage(url: url,
                       content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            },
                       placeholder: {
                ProgressView() // loading placeholder
            })
            
        } else {
            Image(systemName: "photo") // default image
        }
    }
    
    
}





#Preview {
    BuildingDetailView()
}
