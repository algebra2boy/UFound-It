//
//  SignUpView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct SignUpView: View {
    @Environment(AuthViewModel.self) private var authViewModel

    @State private var email: String = ""
    @State private var verificationCode: String = ""
    @State private var password: String = ""
    @State private var backgroundImg: String = "background-umass2"
    @State private var username: String = ""
    
    @State private var isSigningInView: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {

                Color.gray.opacity(0.15)

                ScrollView {
                    AuthHeaderView(backgroundImg: $backgroundImg)
                        .padding()

                    UserNamePasswordView(
                        email: $email,
                        verificationCode: $verificationCode,
                        password: $password,
                        isSignInView: $isSigningInView,
                        username: $username,
                        buttonAction: signUp,
                        verfificationButtonAction: verifyEmail)
                    .frame(width: 350)

                    HStack {
                        Text("Have an account? ")
                            .bold()

                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Login")
                                .underline()
                                .foregroundColor(Color.UmassRed)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
        }
    }
    private func signUp() {
        Task {
            print("i am signin")
            await authViewModel.signup(username: username, email: email, verificationCode: Int(verificationCode) ?? 0000, password: password)
        }
    }
    
    private func verifyEmail() {
        Task {
            print("verify code")
            await authViewModel.verify(email: email)
        }
    }
}

#Preview {
    SignUpView()
        .environment(AuthViewModel())
}
