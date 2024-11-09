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

    @State private var postViewModel: PostViewModel = .init()

    @State private var ItemName = ""
    @State private var additionalNote = ""

    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image? = nil

    var body: some View {
        VStack {
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
                        Task {
                            await postViewModel.saveLostItem()
                        }
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity, minHeight: 20)
                    }
                    .padding(.horizontal, 12)
                    .buttonStyle(.borderedProminent)
                }
            }

            VStack(alignment: .center) {
                Text("Contact Details")
                    .font(.system(size: 17, weight: .bold))
                    .frame(alignment: .center)
                Text("Bob Johnson Joe")
                    .font(.system(size: 15, weight: .light))
                    .frame(alignment: .center)
                Text("bobjohnsonjoe@gmail.com")
                    .font(.system(size: 15, weight: .light))

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
