//
//  PostResponse.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import Foundation

struct SaveItemResponse: Codable {
    let itemId: String
    let status: String
    let message: String
}

// post item `/api/items/add`
struct PostItemResponse: Codable {
    let itemId: String
    let name: String
    let description: String
    let additionalNote: String?
    let location: String
    var boxId = UUID()
    let imageUrl: String
    let currentOwnerEmail: String
    let currentOwnerName: String
    let isClaimed: Bool
}

