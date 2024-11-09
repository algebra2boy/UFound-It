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
    @State private var backgroundImg: String = "background-umass2"
    
    @State private var isSigningInView: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {

                Color.gray.opacity(0.15)

                VStack {

                    AuthHeaderView(backgroundImg: $backgroundImg)
                        .padding()
                    
                    Text("Sign in")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.UmassRed)

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
                                .foregroundColor(Color.UmassRed)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    SignUpView()
}
