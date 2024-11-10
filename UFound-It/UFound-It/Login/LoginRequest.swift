//
//  LoginRequest.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/10/24.
//

struct SignUpRequest: Encodable {
    let name: String
    let email: String
    let verificationCode: Int
    let password: String
}

struct VerifyRequest: Encodable {
    let to: String
}

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

