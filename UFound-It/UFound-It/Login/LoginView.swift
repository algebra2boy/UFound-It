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
    @State private var backgroundImg: String = "background-umass"
    var isSignInButtonDisabled: Bool {
        [username, password].contains(where: \.isEmpty)
    }
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.gray.opacity(0.15)
                
                VStack {
                    
                    AuthHeaderView(backgroundImg: $backgroundImg)
                        .padding()
                                        
                    Text("Login in")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 152 / 255, green: 33 / 255, blue: 28 / 255))
                    
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
                                .foregroundColor(Color(red: 152 / 255, green: 33 / 255, blue: 28 / 255))
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
    LoginView()
}
