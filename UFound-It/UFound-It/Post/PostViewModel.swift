//
//  PostViewModel.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

@Observable class PostViewModel {

    init() { }
    
    @Published var post: PostItemResponse?

    func saveLostItem(lostItem: LostItem, imageData: Data) async {

        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/items/add") else {
            print("Invalid URL")
            return
        }

        let boundary = UUID().uuidString

        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // Create multipart body
        var body = Data()

        // Append each lostItem property as form data
        appendFormField(&body, boundary: boundary, name: "name", value: lostItem.name)
        appendFormField(&body, boundary: boundary, name: "email", value: lostItem.email)
        appendFormField(&body, boundary: boundary, name: "userName", value: lostItem.userName)
        appendFormField(&body, boundary: boundary, name: "description", value: lostItem.description)
        appendFormField(&body, boundary: boundary, name: "additionalNote", value: lostItem.additionalNote)
        appendFormField(&body, boundary: boundary, name: "location", value: lostItem.location)
        appendFormField(&body, boundary: boundary, name: "boxId", value: String(lostItem.boxId))

        // Append the image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"lostItem.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                print("Failed to get response, status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return
            }

            guard let saveItemResponse = try? JSONDecoder().decode(SaveItemResponse.self, from: data) else {
                print("Failed to decode response")
                return
            }

            print("Item ID: \(saveItemResponse.itemId)")
            print("Status: \(saveItemResponse.status)")
            print("Message: \(saveItemResponse.message)")

        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func appendFormField(_ body: inout Data, boundary: String, name: String, value: String) {
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: .utf8)!)
        body.append("\r\n".data(using: .utf8)!)
        body.append("\(value)\r\n".data(using: .utf8)!)
    }
}
