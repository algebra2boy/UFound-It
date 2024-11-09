//
//  PostItemCardView.swift
//  UFound-It
//
//  Created by CHENGTAO LIN on 11/9/24.
//

import SwiftUI

struct PostItemCardView: View {
    let title: String
    @Binding var descriptionText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(alignment: .firstTextBaseline, spacing: 9) {
                // Title
                Text(title)
                    .kerning(1.0)
                    .font(.title2)
                Spacer()
            }
            HStack(alignment: .firstTextBaseline) {
                TextField("writing here", text: $descriptionText)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .lineSpacing(2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
                .shadow(color: Color(.sRGB, red: 0/255, green: 0/255, blue: 0/255).opacity(0.06), radius: 8, x: 0, y: 4)
        }
        .padding(.horizontal)

    }
}

#Preview {
    
    @Previewable @State var descriptionText: String = ""
    
    let titleText: String = "title"
    
    PostItemCardView(title: titleText , descriptionText: $descriptionText)
}
