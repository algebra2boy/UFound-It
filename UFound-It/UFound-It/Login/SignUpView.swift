//
//  SignUpView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct SignUpView: View {

    @State private var username: String = ""

    @State private var password: String = ""

    @State private var isSigningInView: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {

                Color.gray.opacity(0.15)

                VStack {

                    AuthHeaderView()

                    UserNamePasswordView(
                        username: $username,
                        password: $password,
                        isSignInButton: $isSigningInView)
                    .frame(width: 350)

                    HStack {
                        Text("Have an account? ")
                            .bold()

                        NavigationLink {
                            LoginView()
                        } label: {
                            Text("Login")
                                .underline()
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.top, 20)
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    SignUpView()
}
