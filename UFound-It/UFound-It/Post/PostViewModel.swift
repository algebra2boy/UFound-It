//
//  PostViewModel.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

@Observable class PostViewModel {

    init() { }

    func saveLostItem() async {

        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/items/add") else { return }

        // testing purpose
        let example1: LostItem = .init(
            name: "waterbottle",
            description: "description",
            additionalNote: "good note",
            location: "worester",
            boxId: 1,
            email: "yongyetan@umass.edu")

        // convert lostitem swift struct to JSON
        guard let jsonData = try? JSONEncoder().encode(example1) else { return }

        // create the URL request
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST" // specify http method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // specify application/json
        request.httpBody = jsonData // add json data to http body

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
