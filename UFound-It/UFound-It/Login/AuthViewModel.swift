//
//  AuthViewModel.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import Foundation

@Observable class AuthViewModel {
    
    var user: User? = nil
    
    init() { }
    
    func login(email: String, password: String) async {
        
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/auth/login") else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: endpointURL)

            guard response is HTTPURLResponse else {
                print("Failed to get response in login")
                return
            }

            guard let loginResponse = try? JSONDecoder().decode(UserResponse.self, from: data) else {
                print("Failed to decode response in login")
                return
            }
            
            user = .init(
                userId: loginResponse.userId,
                name: loginResponse.name,
                email: loginResponse.email,
                token: loginResponse.token)
            
            print(user)

        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
}
