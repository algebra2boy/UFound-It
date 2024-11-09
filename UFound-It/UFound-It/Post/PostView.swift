//
//  PostView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/8/24.
//

import SwiftUI
import MapKit
import PhotosUI

struct PostView: View {

    @State private var ItemName = ""
    @State private var additionalNote = ""

    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    if let image = selectedImage {
                        VStack {
                            image
                                .resizable()
                                .scaledToFit()
                                .clipped()
                                .cornerRadius(34)
                                .padding()

                            PhotosPicker("Reselect a picture", selection: $pickerItem, matching: .images)
                        }
                    } else {
                        PhotosPicker(selection: $pickerItem, matching: .images) {
                            VStack {
                                Image(systemName: "plus.circle")
                                    .font(.largeTitle)
                                    .scaledToFill()
                                    .frame(height: 100)
                                    .clipped()
                                    .cornerRadius(34)
                                    .padding()
                                Text("Select a picture")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .padding()
                .onChange(of: pickerItem) {
                    selectPhoto()
                }

                PostItemCardView(title: "Name of item", descriptionText: $ItemName)

                PostItemCardView(title: "Note (optional)", descriptionText: $additionalNote)

                Button {

                } label: {
                    Text("Submit")
                        .frame(maxWidth: .infinity, minHeight: 20)
                }
                .padding(.horizontal, 12)
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private func selectPhoto() {
        Task {
            selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
        }
    }
}

#Preview {
    PostView()
}
