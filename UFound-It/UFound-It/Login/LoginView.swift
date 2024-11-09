//
//  LoginView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct LoginView: View {
    @State private var isShowingLogin: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    var isSignInButtonDisabled: Bool {
        [username, password].contains(where: \.isEmpty)
    }
    var body: some View {
        ZStack {
            
            Color.gray.opacity(0.15)
            
            VStack {
                
                Spacer()
                
                Image("background-umass")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 356, height: 480)
                    .clipped()
                    .overlay(alignment: .topLeading) {
                        // Hero
                        VStack(alignment: .leading, spacing: 11) {
                            // App Icon
                            RoundedRectangle(cornerRadius: 17, style: .continuous)
                                .fill(.white)
                                .frame(width: 72, height: 72)
                                .clipped()
                                .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.12), radius: 8, x: 0, y: 4)
                                .overlay {
                                    Image("umass-amherst-icons")
                                        .resizable()
                                        .scaledToFit()
                                }

                            VStack(alignment: .leading, spacing: 1) {
                                Text("UFound-It")
                                    .font(.system(.largeTitle, weight: .medium))
                                    .foregroundStyle(.white)
                                Text("Welcome to UFound-It ")
                                    .font(.system(.callout, weight: .medium))
                                    .frame(width: 190, alignment: .leading)
                                    .clipped()
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding()
                    }
                    .mask {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                    }
                    .shadow(color: Color(.sRGBLinear, red: 0/255, green: 0/255, blue: 0/255).opacity(0.15), radius: 18, x: 0, y: 14)
                
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
                        print("do login action")
                    } label: {
                        Text("Login In")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        isSignInButtonDisabled ?
                        LinearGradient(colors: [.gray], startPoint: .topLeading, endPoint: .bottomTrailing) :
                            LinearGradient(
                                colors: [.red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .cornerRadius(20)
                    .disabled(isSignInButtonDisabled)
                    .padding()
                }
                .frame(width: 356)
                
                Spacer()
                
                Spacer()
            }
        }
        .ignoresSafeArea()

    }
    
}

#Preview {
    LoginView()
}
