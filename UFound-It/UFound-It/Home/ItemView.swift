//  ItemView.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct ItemView: View {
    
    @State private var isShowingSheet = false
    @State private var isShowingLock = false
    @State private var isPressed = false
    @State private var isClaimed = false
    @State private var showingAlert = false
    @State private var name = ""
    
    
    let item: ItemsByLocation
    let buildingName: String

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    asyncImage(url: item.imageUrl)
                        .clipped()
                        .cornerRadius(20)
                        .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing: 18))
                    
                    Text("\(item.name)")
                        .font(.system(size: 26, weight: .bold))
                        .padding(EdgeInsets(top: 2, leading: 18, bottom: 5, trailing: 18))

                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("\(buildingName)")
                                .font(.system(size: 19, weight: .medium))
                                .padding()
                            Spacer()
                        }
                        
                        Label("\(buildingName)", systemImage: "mappin.and.ellipse")
                            .padding(EdgeInsets(top: 0, leading: 46, bottom: 0, trailing: 0))
                        
                        Label("Box #\(item.boxId)", systemImage: "shippingbox.fill")
                            .padding(EdgeInsets(top: 0, leading: 46, bottom: 0, trailing: 0))
                        
                        Text("Description")
                            .font(.system(size: 19, weight: .medium))
                            .padding()
                        
                        Text("\(item.description)")
                            .font(.system(size: 17, weight: .light))
                            .padding([.leading, .trailing], 48)
                        
                        Spacer()
                    }
                    .padding([.horizontal, .bottom], 10)
                }

                VStack(alignment: .center) {
                    Text("Contact Details")
                        .font(.system(size: 17, weight: .bold))
                        .frame(alignment: .center)
                    
                    Text("\(item.currentOwnerName)")
                        .font(.system(size: 15, weight: .light))
                        .frame(alignment: .center)
                    
                    Text("\(item.currentOwnerEmail)")
                        .font(.system(size: 15, weight: .light))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isShowingSheet.toggle()
                    }) {
                        Text("Is This Yours?")
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                ClaimSheet(
                    isShowingSheet: $isShowingSheet,
                    isShowingLock: $isShowingLock,
                    isPressed: $isPressed,
                    isClaimed: $isClaimed,
                    name: item.currentOwnerName,
                    itemId: item.itemId,
                    email: item.currentOwnerEmail
                )
                .presentationDragIndicator(.visible)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Not Mine") {
                            isShowingSheet.toggle()
                        }
                        .padding(15)
                    }
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
                .frame(maxWidth: .infinity)
        }
    } else {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 200)
    }
}

#Preview {
    let item: ItemsByLocation = .init(
        itemId: "6c94d63b-d182-475a-a3a4-19d04cc669ee",
        name: "Item",
        description: "This is an item",
        additionalNote: "This is an additional note",
        location: "LGRC",
        boxId: 5,
        imageUrl: "https://www.pennington.com/-/media/Project/OneWeb/Pennington/Images/blog/seed/10-Surprising-Facts-About-Grass/grass_10surprising_opengraph.jpg",
        currentOwnerEmail: "ghigh@umass.edu",
        currentOwnerName: "ghigh",
        isClaimed: false
    )
    ItemView(item: item, buildingName: "Fun place")
}
