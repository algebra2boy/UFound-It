//
//  UserProfileView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import Foundation
import SwiftUI

struct UserProfileView: View {

    @Environment(AuthViewModel.self) var authViewModel

    @State private var username: String = "Username"
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    // User profile image and name
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "person.circle")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .mask { RoundedRectangle(cornerRadius: 67, style: .continuous) }
                                .foregroundStyle(Color.UmassRed)
//                            Image(systemName: "pencil")
//                                .foregroundColor(Color.primary)
//                                .padding(8)
//                                .background(Color.white)
//                                .clipShape(Circle())
//                                .offset(x: 10, y: -10)
                                }
                                .padding()
                        Text(username)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.primary)
                    }
                    .padding()
                    
                    // Item and claimed info
                    HStack {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                            VStack {
                                Text("100")
                                    .font(.system(.headline, weight: .semibold))
                                Text("You lost")
                                    .font(.footnote)
                            }
                            .frame(width: 80)
                            .clipped()
                            VStack {
                                Text("100")
                                    .font(.system(.headline, weight: .semibold))
                                Text("Found")
                                    .font(.footnote)
                            }
                            .frame(width: 80)
                            .clipped()
                            VStack {
                                Text("100")
                                    .font(.system(.headline, weight: .semibold))
                                Text("Claimed")
                                    .font(.footnote)
                            }
                            .frame(width: 80)
                            .clipped()
                        }
                    }
                    .foregroundStyle(.secondary)
                    .font(.title2)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 4)
                    
                    Divider()
                    
                    // User info
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundStyle(Color.UmassRed)
                            Text("useremail@example.com")
                                .font(.body)
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 78)
            }
            
            Spacer() // Pushes the buttons to the bottom
            
            // Update Button
//            Button {
//                // TODO: Button ACTION
//                print("do login action")
//            } label: {
//                Text("Update")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal)
            
            // Sign Out Button
            Button {
                authViewModel.user = nil
                print("do sign out action")
            } label: {
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.UmassRed)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20) // Add extra padding at the bottom if desired
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    UserProfileView()
}
