//
//  UserNamePasswordView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct UserNamePasswordView: View { // Corrected struct name
    
    @Binding var username: String
    @Binding var password: String
    @Binding var isSignInButton: Bool
    
    var isSignInButtonDisabled: Bool {
        [username, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 11) {
                Text("UserName")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                
                TextField("", text: $username)
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.primary)
                    .frame(height: 44)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .cornerRadius(15.0)
            }
            VStack(alignment: .leading, spacing: 11) {
                Text("Password")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                
                SecureField("", text: $password)
                    .font(.system(size: 17, weight: .thin))
                    .foregroundColor(.primary)
                    .frame(height: 44)
                    .padding(.horizontal, 12)
                    .background(Color.white)
                    .cornerRadius(15.0)
            }
            Button {
                // TODO: Button ACTION
                print("do login action")
            } label: {
                (isSignInButton ? Text("Sign In") : Text("Log In")) // Corrected syntax
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: isSignInButtonDisabled ? [.gray] : [Color(red: 152 / 255, green: 33 / 255, blue: 28 / 255), Color(red: 152 / 255, green: 33 / 255, blue: 28 / 255)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(20)
            .disabled(isSignInButtonDisabled)
            .padding()
            
        }
    }
}

#Preview {
//    @Previewable @State var descriptionText: String = ""
    @Previewable @State var isSignInButton: Bool = false
    @Previewable @State var username: String = "ss"
    @Previewable @State var password: String = "sss"
    UserNamePasswordView(username: $username, password: $password, isSignInButton: $isSignInButton)
}
