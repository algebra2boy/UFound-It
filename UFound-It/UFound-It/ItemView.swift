//
//  ItemView.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct ItemView: View {
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                ScrollView {
                    asyncImage(url: "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEglLaLDQjsbMAYFLzkE38lL3JCIRFL0yr71tgUhao6lbIEnn-0qX2ycC15DerAKRc_G_D1sDDa67A1Oc-JogX09WQA6XxjLsg2sDLcLWexjKOdkX8HnUAVy4hyphenhyphen3bKMrN4UEdsE4SO4Yj5Wz/s5046/Dederick+7-01-01.JPG")
                        .clipped()
                        .cornerRadius(20)
                        .padding(EdgeInsets(top: 10, leading: 18, bottom: 6, trailing:18))
                    Text("Golden Pencil")
                        .font(.system(size: 26, weight: .bold))
                    .padding(EdgeInsets(top: 2, leading: 18, bottom: 5, trailing:18))
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack() {
                            Text("Morrill Sci Center")
                                .font(.system(size: 19, weight: .medium))
                                .padding()
                            Spacer()
                            Text("Box #1")
                                .font(.system(size: 19, weight: .light))
                                .padding()
                        }
                        Label("80 Drive St", systemImage: "mappin.and.ellipse")
                            .padding(EdgeInsets(top: 0, leading: 46, bottom: 0, trailing:0))
                        Label("10:00 PM", systemImage: "clock.fill")
                            .padding(EdgeInsets(top: 0, leading: 46, bottom: 0, trailing:0))
                        
                        Text("Description")
                            .font(.system(size: 19, weight: .medium))
                            .padding()
                        Text("Lorem ipsum dolor sit amet, connect adipiscing elit.")
                            .font(.system(size: 17, weight: .light))
                            .padding([.leading, .trailing], 48)
                        
                        Spacer()
                        
                        
                        
                        VStack(alignment: .center, spacing: 10) {
                            Text("Bob Johnson Joe")
                                .font(.system(size: 19, weight: .medium))
                                .padding()
                                .frame(alignment: .center)
                            Text("bobjohnsonjoe@gmail.com")
                                .font(.system(size: 17, weight: .light))
                                .padding([.leading, .trailing])
                                         }
                        
                        
                    }
                    .padding([.horizontal, .bottom], 10)
                    
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "arrow.backward")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Status: Claimed")
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 1)
                        }
                }
            }
            
            
        }
    }
}


@ViewBuilder
func asyncImage(url: String) -> some View {
    if let url = URL(string: url) {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
        } placeholder: {
            ProgressView()
                .frame(maxWidth: .infinity)
        }
    } else {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 200)
    }
}

#Preview {
    ItemView()
}
