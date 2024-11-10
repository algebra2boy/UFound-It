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
}
