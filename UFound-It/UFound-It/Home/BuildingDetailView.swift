//
//  BuildingDetailView.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct BuildingDetailView: View {
    
    @Environment(HomeViewModel.self) private var homeViewModel: HomeViewModel
    
    @State private var searchText: String = ""
    
    @State private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var navigateToPostView = false
    
    @Binding var present: Bool
    
    @Binding var detent: PresentationDetent
    
    @State var buildingName: String
    
    //let data = (1...2).map { "Item \($0)" }
    
    @State private var navigateToItemView: Bool = false
    
    //@State private var selectedItem:
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                ScrollView {
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        ForEach(homeViewModel.boxItemsByLocation, id: \.self) { item in
                            
                            GeometryReader { geometry in
                                ItemCardView(item: item)
                                .background(Color.white)
                                .cornerRadius(15)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray, lineWidth: 0.5)
                                }
                                .onTapGesture {
                                    //selectedItem = item
                                    navigateToItemView.toggle()
                                }
                            }
                            .frame(height: 200)
                        }
                    }
                    .padding()
                }
            }
            .task {
                await homeViewModel.fetchByBuilding(with: buildingName)
            }
            
            .navigationDestination(isPresented: $navigateToItemView, destination: {
                ItemView()
            })
            
            .searchable(text: $searchText, prompt: "Search for lost items")
            .navigationTitle("\(buildingName)")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDragIndicator(.visible)
//            .toolbar {
//                
//                ToolbarItem(placement: .topBarLeading) {
//                    Button {
//                        present.toggle()
//                    } label: {
//                        Image(systemName: "xmark")
//                    }
//                }
//                
//                ToolbarItem(placement: .topBarTrailing) {
//                    HStack {
//                        sortMenu
//                        
//                        Button {
//                            navigate()
//                        } label: {
//                            Image(systemName: "plus")
//                        }
//                    }
//                }
//            }
            .navigationDestination(isPresented: $navigateToPostView, destination: {
                PostView(buildingName: buildingName)
            })
            
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
                    .frame(maxWidth: .infinity, maxHeight: 200)
            }
        } else {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 200)
        }
    }
    
    private func navigate() {
        
        if detent != .large {
            detent = .large
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                navigateToPostView = true
            }
        } else {
            navigateToPostView = true
        }
    }
}

#Preview {
    
    @Previewable @State var present: Bool = false
    
    @Previewable @State var detent: PresentationDetent = .large
    
    BuildingDetailView(present: $present, detent: $detent, buildingName: "UMASS")
        .environment(HomeViewModel())
}


