//
//  LocationResponse.swift
//  UFound-It
//
//  Created by Yongye on 11/9/24.
//


struct LocationResponse: Codable, Hashable {
    let locations: [BoxLocation]
    let status: String
}

struct BoxLocation: Codable, Hashable {
    let location: String
    let lat: Double
    let long: Double
}
