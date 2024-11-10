//
//  LoginView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var verificationCode: String = ""

    @State private var isSigningInView: Bool = false
    @State private var backgroundImg: String = "background-umass"
    var isSignInButtonDisabled: Bool {
        [email, password].contains(where: \.isEmpty)
    }
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color.gray.opacity(0.15)
                
                VStack {
                    
                    AuthHeaderView(backgroundImg: $backgroundImg)
                        .padding()
//                                        
//                    Text("Log in")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundColor(Color.UmassRed)
                    
                    UserNamePasswordView(
                        email: $email,
                        verificationCode: $verificationCode,
                        password: $password,
                        isSignInView: $isSigningInView)
                    .frame(width: 350)
                    
                    HStack {
                        Text("Don't have an account? ")
                            .bold()
                        
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign up")
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
    LoginView()
}
