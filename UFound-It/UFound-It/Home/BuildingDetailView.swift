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
    
    @State private var navigateToPostView = false
    
    @Binding var present: Bool
    
    @Binding var detent: PresentationDetent
    
    let data = (1...2).map { "Item \($0)" }
    
    @State private var navigateToItemView: Bool = false
    
    //@State private var selectedItem:
    
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
            
            .navigationDestination(isPresented: $navigateToItemView, destination: {
                ItemView()
            })
            
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
                        
                        Button {
                            navigate()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToPostView, destination: {
                PostView()
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
    
    BuildingDetailView(present: $present, detent: $detent)
}


