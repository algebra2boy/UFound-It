//
//  ItemView.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct ItemView: View {
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                ScrollView {
                    
                    Text("dajkhfasfas")
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {

                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Status: Claimed")
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        }
                }
            }
            
            
        }
    }
}




#Preview {
    ItemView()
}
