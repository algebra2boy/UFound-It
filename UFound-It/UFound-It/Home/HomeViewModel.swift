//
//  HomeViewModel.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

@Observable class HomeViewModel {
    
    var boxLocations: [BoxLocation] = []
    var filteredLocations: [BoxLocation] = []
    var selectedLocation: BoxLocation? = nil
    
    
    init() { }
    
    func fetchAllLocations() async {
        
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/locations/list") else { return }
        
        
        do {
            let (data, response) = try await URLSession.shared.data(from: endpointURL)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
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

}


