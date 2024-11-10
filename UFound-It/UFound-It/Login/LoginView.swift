//
//  LoginView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AuthViewModel.self) private var authViewModel
    
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
                    
                    UserNamePasswordView(
                        email: $email,
                        verificationCode: $verificationCode,
                        password: $password,
                        isSignInView: $isSigningInView,
                        buttonAction: login,
                        verfificationButtonAction: {}
                    )
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
    
    private func login() {
        Task {
            print("i am loggining")
            await authViewModel.login(email: "georgezhang744@umass.edu", password: "12345678")
        }
    }

}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
