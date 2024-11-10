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
    
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(\.dismiss) private var dismiss


    @State private var postViewModel: PostViewModel = .init()

    @State private var itemName = ""
    @State private var description = ""

    @State private var additionalNote: String = ""
    @State private var boxId: Int = 0

    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image? = nil
    
    var boxes: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @State private var selectedBoxId = 1


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
                    
                    VStack(alignment: .leading) {
                        Text("Select a box ID")
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(.secondary)
                            .frame(height: 15, alignment: .leading)
                            .padding(.horizontal)

                        Picker("Please choose a box ID", selection: $selectedBoxId) {
                            ForEach(boxes, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding()
                    }
                    
                    PostItemCardView(title: "Name of item", descriptionText: $itemName)
                    

                    PostItemCardView(title: "Description", descriptionText: $description)

                    PostItemCardView(title: "Note (optional)", descriptionText: $additionalNote)

                    Button {
                        submitLostItem()
                        dismiss()
                        
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: .infinity, minHeight: 20)
                    }
                    .padding(.horizontal, 12)
                    .buttonStyle(.borderedProminent)
                    .tint(.UmassRed)
                    
                    


                }
                VStack(alignment: .leading) {
                    Text("Ensure that item is in the box and door is closed before submitting. \(authViewModel.user?.name ?? "Your name") and \(authViewModel.user?.email ?? "your email") will be included in the lost item report.")
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding()

                }
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
                name: itemName,
                email: authViewModel.user?.email ?? "unknown@gmail.com",
                userName: authViewModel.user?.name ?? "unknown",
                description: description,
                additionalNote: additionalNote,
                location: buildingName,
                boxId: selectedBoxId)

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
        .environment(AuthViewModel())
}
