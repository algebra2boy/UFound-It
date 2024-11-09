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

                    LazyVGrid(columns: columns, spacing: 20) {

                        ForEach(data, id: \.self) { item in

                            GeometryReader { geometry in
                                VStack(alignment: .leading, spacing: 10) {

                                    asyncImage(url: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEglLaLDQjsbMAYFLzkE38lL3JCIRFL0yr71tgUhao6lbIEnn-0qX2ycC15DerAKRc_G_D1sDDa67A1Oc-JogX09WQA6XxjLsg2sDLcLWexjKOdkX8HnUAVy4hyphenhyphen3bKMrN4UEdsE4SO4Yj5Wz/s5046/Dederick+7-01-01.JPG")
                                        .clipped()

                                    // Text Section
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("\(item)")
                                            .font(.system(size: 18, weight: .medium))

                                        Text("Posted @ 5:00pm")
                                            .font(.system(size: 16, weight: .light))
                                    }
                                    .padding([.horizontal, .bottom], 10)

                                }
                                .background(Color.white)
                                .cornerRadius(15)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, lineWidth: 0.5)
                                }
                            }
                            .frame(height: 200) // Fixed height for each grid item
                        }
                    }
                    .padding()
                }
            }

            .searchable(text: $searchText, prompt: "Search for lost items")
            .navigationTitle("Franklin Dining Hall")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.fraction(0.4)])
            .presentationDragIndicator(.visible)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    NavigationLink {
                        PostView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    @ViewBuilder
    func asyncImage(url: String) -> some View {
        if let url = URL(string: url) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity) // Ensure the progress view spans the full width
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit() // Scale the default image to fit inside the container
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }

}

#Preview {
    BuildingDetailView()
}


