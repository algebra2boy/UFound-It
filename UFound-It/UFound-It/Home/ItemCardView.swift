//
//  ItemCardView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct ItemCardView: View {
    let item: ItemsByLocation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            asyncImage(url: item.imageUrl)
                .clipped()
            
            VStack(alignment: .leading, spacing: 5) {
                Text("\(item.name)")
                    .font(.system(size: 18, weight: .medium))
                
                Text("\(item.currentOwnerName)")
                    .font(.system(size: 16, weight: .light))
            }
            .padding([.horizontal, .bottom], 10)
        }
    }
}
