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

    @Binding var present: Bool

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
                            .frame(height: 200)
                        }
                    }
                    .padding()
                }
            }

            .searchable(text: $searchText, prompt: "Search for lost items")
            .navigationTitle("Franklin Dining Hall")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDragIndicator(.visible)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        present.toggle()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        sortMenu

                        NavigationLink {
                            PostView()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }

    var sortMenu: some View {
        Menu {

            Button {

            } label: {
                HStack {
                    Text("A-Z")
                    Spacer()
                    Image(systemName: "character")
                }
            }

            Button {

            } label: {
                Text("Latest")
            }

            Button {

            } label: {
                Text("Oldest")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
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
                    .frame(maxWidth: .infinity)
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }


}

#Preview {

    @Previewable @State var present: Bool = false

    BuildingDetailView(present: $present)
}


