//
//  PostViewModel.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

@Observable class PostViewModel {
    
    init() { }
    
    func saveLostItem(lostItem: LostItem, imageData: Data) async {
        
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/items/add") else { return }
        
        
        let boundary = UUID().uuidString
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST" // specify http method
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create multipart body
        var body = Data()
        
        if let jsonData = try? JSONEncoder().encode(lostItem) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"json\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
            body.append(jsonData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
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
                print("Failed to get response")
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
            print("error: \(error.localizedDescription)")
        }
        
    }
}
