//
//  LostItem.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

struct LostItem: Codable {

    var name: String

    var email: String

    var userName: String

    var description: String

    var additionalNote: String

    var location: String

    var boxId: Int
    
    init(name: String, email: String, userName: String, description: String, additionalNote: String, location: String, boxId: Int) {
        self.name = name
        self.email = email
        self.userName = userName
        self.description = description
        self.additionalNote = additionalNote
        self.location = location
        self.boxId = boxId
    }
}
