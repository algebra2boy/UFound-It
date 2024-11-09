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

    let data = (1...2).map { "Item \($0)" }

    var body: some View {
        NavigationStack {

            VStack {

                ScrollView {

                    LazyVGrid(columns: columns, spacing: 30) {

                        ForEach(data, id: \.self) { item in

                            VStack(alignment: .leading, spacing: 0) {

                                VStack(alignment: .leading) {
                                    asyncImage(url: "https://upload.wikimedia.org/wikipedia/commons/a/a2/Yellow_Transparent_%28cropped%29.jpg")
                                        .frame(height: 200)
                                }
                                .cornerRadius(10)
                                .clipped()

                                HStack {
                                    Text("Name: \(item)")
                                        .font(.system(size: 20, weight: .light))
                                }
                                .padding(.horizontal, 5)

                                HStack {
                                    Text("Posted @ 5:00pm")
                                        .font(.system(size: 20, weight: .light))
                                }
                                .padding(.horizontal, 5)
                            }
                            .cornerRadius(10)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 5)
                            }
                        }
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
func asyncImage(url: String) -> some View {
    if let url = URL(string: url) {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            ProgressView()
        }
    } else {
        Image(systemName: "photo") // default image
    }
}

#Preview {
    BuildingDetailView()
}
