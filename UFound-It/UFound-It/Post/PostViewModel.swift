//
//  PostViewModel.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

@Observable class PostViewModel {

    init() { }

    func saveLostItem() {


        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/items/add") else { return }

//        fetch data asynchronously from the server url
//        let (data, _) = try await URLSession.shared.data(from: serverURL)
//
//        // parse the JSON data to swift struct
//        var items = try JSONDecoder().decode([ListItem].self, from: data)



    }
}
