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
        ZStack {
            
            Color.gray.opacity(0.15)
            VStack {
                
                Spacer()
                AuthHeaderView()
                    .padding()
                UserNamePasswordView(
                    username: $username,
                    password: $password,
                    isSignInButton: $isSigningInView)
                .frame(width: 350)
                Spacer()
                Spacer()
            }
        }
        .ignoresSafeArea()
        }
}

#Preview {
    SignUpView()
}
