//
//  UserResponse.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//


import Foundation

struct UserResponse: Codable {
    let userId: String
    let name: String
    let email: String
    let token: String
    let status: String
}

struct User: Codable {
    let userId: String
    let name: String
    let email: String
    let token: String
}

