//
//  LostItem.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//

import Foundation

struct LostItem {

    var name: String

    var description: String

    var additionalNote: String

    var location: String

    var boxID: Int

    var email: String // the email of the user

    init(name: String, description: String, additionalNote: String, location: String, boxID: Int, email: String) {
        self.name = name
        self.description = description
        self.additionalNote = additionalNote
        self.location = location
        self.boxID = boxID
        self.email = email
    }
}
