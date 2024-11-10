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

    @State private var itemName = ""
    @State private var description = ""

    @State private var additionalNote = ""

    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image? = nil

    var buildingName: String

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
                                        .foregroundStyle(Color.UmassRed)
                                        .padding()
                                    Text("Select a picture")
                                        .foregroundStyle(Color.UmassRed)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .padding()
                    .onChange(of: pickerItem) {
                        selectPhoto()
                    }

                    PostItemCardView(title: "Name of item", descriptionText: $itemName)

                    PostItemCardView(title: "Description", descriptionText: $description)


                    PostItemCardView(title: "Note (optional)", descriptionText: $additionalNote)

                    Button {
                        submitLostItem()
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity, minHeight: 20)
                    }
                    .padding(.horizontal, 12)
                    .buttonStyle(.borderedProminent)
                    .tint(.UmassRed)
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

    private func submitLostItem() {
        Task {

            let lostItem: LostItem = .init(
                name: "Item",
                email: "yongyetan@umass.edu",
                userName: "yongye",
                description: "This is an item",
                additionalNote: "",
                location: "Franklin",
                boxId: 10)

            if let pickerData = try? await pickerItem?.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: pickerData) {

                // Convert UIImage to JPEG Data
                let imageData = uiImage.jpegData(compressionQuality: 0.8)!

                await postViewModel.saveLostItem(lostItem: lostItem, imageData: imageData)
            }
        }
    }
}

#Preview {
    PostView(buildingName: "ABC")
}
