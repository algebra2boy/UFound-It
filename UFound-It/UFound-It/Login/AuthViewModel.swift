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
    
    func verify(email: String) async {
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/auth/presignup") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(VerifyRequest(to: email))
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Failed to verify email with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            print("Email verification initiated successfully")
            
        } catch {
            print("Failed to verify email: \(error)")
        }
    }

    func signup(username: String, email: String, verificationCode: Int, password: String) async {
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/auth/signup") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(SignUpRequest(name: username, email: email, verificationCode: verificationCode, password: password))
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Failed to get response in signup with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            guard let signupResponse = try? JSONDecoder().decode(SignUpResponse.self, from: data) else {
                print("Failed to decode signup response")
                return
            }
            
            print("Signup successful: \(signupResponse)")
            
        } catch {
            print("Failed to signup: \(error)")
        }
    }

    
    func login(email: String, password: String) async {
        
        guard let endpointURL = URL(string: "\(Constants.APIURL)/api/auth/login") else { return }
        
        var request = URLRequest(url: endpointURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(LoginRequest(email: email, password: password))

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

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
            
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }

}
