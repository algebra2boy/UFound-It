//
//  UserNamePasswordView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct UserNamePasswordView: View { // Corrected struct name
    
    @Binding var email: String
    @Binding var verificationCode: String
    @Binding var password: String
    @Binding var isSignInView: Bool
    @Binding var username: String
    
    let buttonAction: () -> Void
    
    let verfificationButtonAction: () -> Void
    
    var isSignInButtonDisabled: Bool {
        [email, password].contains(where: \.isEmpty)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 11) {
                Text("UMass email")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.secondary)
                    .frame(height: 15, alignment: .leading)
                
                HStack {
                    TextField("", text: $email)
                        .font(.system(size: 17, weight: .thin))
                        .foregroundColor(.primary)
                        .frame(height: 44)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(15.0)
                        .textInputAutocapitalization(.none)
                    
                    if isSignInView {
                        Button(action: {
                            // Add action here
                            verfificationButtonAction()
                        }) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 50, height: 44)
                                .background(Color.UmassRed)
                                .cornerRadius(12.0)
                        }
                    }
                }
            }
            
            if isSignInView {
                VStack(alignment: .leading, spacing: 11) {
                    Text("Verification Code")
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(.secondary)
                        .frame(height: 15, alignment: .leading)
                    
                    TextField("", text: $verificationCode)
                        .font(.system(size: 17, weight: .thin))
                        .foregroundColor(.primary)
                        .frame(height: 44)
                        .padding(.horizontal, 12)
                        .background(Color.white)
                        .cornerRadius(15.0)
                    
                    VStack(alignment: .leading, spacing: 11) {
                        Text("username")
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
                            .textInputAutocapitalization(.none)
                    }
                }
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
                buttonAction()
            } label: {
                (isSignInView ? Text("Sign In") : Text("Log In"))
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: isSignInButtonDisabled ? [.gray] : [Color.UmassRed],
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
    @Previewable @State var isSignInView: Bool = true
    @Previewable @State var verificationCode: String = "sss"
    @Previewable @State var email: String = "sss"
    @Previewable @State var password: String = "sss"
    @Previewable @State var username: String = "sss"

    UserNamePasswordView(email: $email,
                         verificationCode: $verificationCode,
                         password: $password,
                         isSignInView: $isSignInView,
                         username: $username,
                         buttonAction: {},
                         verfificationButtonAction: {})
}
