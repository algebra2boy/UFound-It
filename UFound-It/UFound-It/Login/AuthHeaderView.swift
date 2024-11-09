//
//  AuthHeaderView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import Foundation
import SwiftUI

struct AuthHeaderView: View {
    var body: some View {
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
    }
}

#Preview {
    AuthHeaderView()
}
