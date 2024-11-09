//
//  LoginView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isSigningInView: Bool = false
    var isSignInButtonDisabled: Bool {
        [username, password].contains(where: \.isEmpty)
    }
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
                        Text("Don't have an account? ")
                            .bold()
                        
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign up")
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
    LoginView()
}
