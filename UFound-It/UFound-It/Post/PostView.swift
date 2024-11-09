//
//  PostView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/8/24.
//

import SwiftUI
import MapKit

struct PostView: View {
    
    @State private var description = ""
    @State private var ItemName = ""

    @State private var additionalNote = ""
    @State private var image: Image? = nil
    @State private var isShowingImagePicker = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button(action: {
                    isShowingImagePicker.toggle()
                }) {
                    VStack {
                        if let image = image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 100)
                                .clipped()
                                .cornerRadius(34)
                                .padding()
                        } else {
                            Image(systemName: "plus.circle")
                                .font(.largeTitle)
                                .scaledToFill()
                                .frame(height: 100)
                                .clipped()
                                .cornerRadius(34)
                                .padding()
                            Text("Upload Pic")
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
                    .sheet(isPresented: $isShowingImagePicker) {
                        // Image picker code here
                    }
                    
                }.sheet(isPresented: $isShowingImagePicker) {
                    
                }
                
                PostItemCardView(title: "Name", descriptionText: $ItemName)

                PostItemCardView(title: "description", descriptionText: $description)
                
                PostItemCardView(title: "Additional Note", descriptionText: $additionalNote)
                
                Button {
                    
                } label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 12)
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    PostView()
}
