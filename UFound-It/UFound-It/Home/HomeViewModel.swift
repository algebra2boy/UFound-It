//
//  HomeViewModel.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

struct BuildingResponse: Codable {
    var items: [ItemsByLocation]
    var status: String
}

struct ItemsByLocation: Codable, Hashable {

    var itemId: String
    var name: String
    var description: String
    var additionalNote: String
    var location: String
    var boxId: Int
    var imageUrl: String
    var currentOwnerEmail: String
    var currentOwnerName: String
    var isClaimed: Bool
}

@Observable class HomeViewModel {

    var boxLocations: [BoxLocation] = []
    var boxItemsByLocation: [ItemsByLocation] = []
    var selectedLocation: BoxLocation? = nil

    var selectedItem: ItemsByLocation? = nil

    init() { }

    func fetchAllLocations() async {
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/locations/list") else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: endpointURL)

            guard response is HTTPURLResponse else {
                print("Failed to get response in fetchAllLocations")
                return
            }

            guard let locationsResponse = try? JSONDecoder().decode(LocationResponse.self, from: data) else {
                print("Failed to decode response in fetchAllLocations")
                return
            }

            boxLocations = locationsResponse.locations

            print(boxLocations)

        } catch {
            print("error: \(error.localizedDescription)")
        }

    }


    func fetchByBuilding(with name: String) async {
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/items/search") else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: endpointURL)

            guard response is HTTPURLResponse else {
                print("Failed to get response in fetchByBuilding")
                return
            }

            guard let ItemsByLocationResponse = try? JSONDecoder().decode(BuildingResponse.self, from: data) else {
                print("Failed to decode response in fetchByBuilding")
                return
            }

            let filteredItems = ItemsByLocationResponse.items.filter { item in
                item.location.lowercased() == name.lowercased()
            }

            boxItemsByLocation = filteredItems

            print(boxItemsByLocation)

        } catch {
            print("error: \(error.localizedDescription)")
        }

    }
    
    
    func changeClaim(with name: String, and itemId: String, and email: String) async { // PUT
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/items/claim") else { return }

        let payload: [String: Any] = [
            "name": name,
            "itemId": itemId,
            "email": email
            ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "PUT"  // Set the request method to PUT
            request.httpBody = jsonData  // Set the body of the request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")  // Specify the content type

            let (_, response) = try await URLSession.shared.data(for: request)

            guard response is HTTPURLResponse else {
                print("Failed to claim the item or invalid response")
                return
            }
            
            print(response)
            
        } catch {
            print("error: \(error.localizedDescription)")
        }

    }
    
    
    func unlockBox(with itemId: String) async { // PUT
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/items/pickup") else { return }

        let payload: [String: Any] = [
                "itemId": itemId
            ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            
            var request = URLRequest(url: endpointURL)
            request.httpMethod = "PUT"  // Set the request method to PUT
            request.httpBody = jsonData  // Set the body of the request
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")  // Specify the content type

            let (_, response) = try await URLSession.shared.data(for: request)

            guard response is HTTPURLResponse else {
                print("Failed to claim the item or invalid response")
                return
            }
            
            print(response)
            
        } catch {
            print("error: \(error.localizedDescription)")
        }

    }
    
}
