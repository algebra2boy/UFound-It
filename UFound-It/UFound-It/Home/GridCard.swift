//
//  GridCard.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct GridCard: View {
    
    
    @Environment(HomeViewModel.self) private var homeViewModel: HomeViewModel
    @Binding var columns: [GridItem]
    @Binding var navigateToItemView: Bool
    @Binding var buildingName: String
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    ForEach(homeViewModel.boxItemsByLocation, id: \.self) { item in
                        
                        GeometryReader { geometry in
                            VStack(alignment: .leading, spacing: 10) {
                                
                                asyncImage(url: item.imageUrl)
                                    .clipped()
                                
                                // Text Section
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("\(item.name)")
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
        
        .task {
            await homeViewModel.fetchByBuilding(with: buildingName)
        }
    }
}

//#Preview {
//    GridCard()
//}
