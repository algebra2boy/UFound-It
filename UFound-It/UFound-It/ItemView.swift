//
//  ItemView.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct ItemView: View {
    
    @State private var isShowingSheet = false
    
    @State private var isShowingLock = false
    
    @State private var isPressed = false
    @State private var isClaimed = false
    
    @State private var showingAlert = false
    @State private var name = ""

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
                    }
                    .padding([.horizontal, .bottom], 10)
                }
                
                VStack(alignment: .center) {
                    Text("Contact Details")
                        .font(.system(size: 17, weight: .bold))
                        .frame(alignment: .center)
                    Text("Bob Johnson Joe")
                        .font(.system(size: 15, weight: .light))
                        .frame(alignment: .center)
                    Text("bobjohnsonjoe@gmail.com")
                        .font(.system(size: 15, weight: .light))
                }
            }
            
            .toolbar {
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button(action: {
                                isShowingSheet.toggle()
                            }) {
                                Text("Is This Yours?")
                            }
                            .sheet(isPresented: $isShowingSheet) {
                                
                                NavigationStack {
                                    VStack {
                                        Text("CLAIM THIS ITEM")
                                            .font(.title)
                                        Text("""
                                            By claiming this item, you ensure that you are the rightful owner, your name and email will be recorded as the new owner. When you tap the claim button, you will have 7 days to unlock the box that contains your item.
                                            """)
                                        .padding(40)
                                        .font(.system(size: 17, weight: .bold))
                                        .frame(alignment: .center)
                                        
                                        Button(action: {
                                            isPressed = true
                                            isClaimed.toggle()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                isPressed = false
                                                isShowingLock.toggle()
                                            }
                                        }) {
                                            Text(isClaimed ? "UNCLAIM" : "CLAIM")
                                                .padding(15)
                                                .frame(width: 200, height: 50)
                                                .foregroundColor(.white)
                                                .background(isClaimed ? .gray : .green)
                                                .cornerRadius(10)
                                                .scaleEffect(isPressed ? 0.85 : 1.0)
                                                .opacity(isPressed ? 0.95 : 1.0)
                                                .animation(.easeInOut(duration: 0.15), value: isPressed)
                                        }
                                        .padding(50)
                                        
                                        ZStack {
                                            Spacer().frame(height: 50)
                                            if isShowingLock {
                                                Button(action: {
                                                    isShowingSheet.toggle()
                                                }) {
                                                    Text("UNLOCK BOX")
                                                }
                                                .padding(15)
                                                .frame(width: 200, height: 50)
                                                .foregroundColor(.white)
                                                .background(.blue)
                                                .cornerRadius(10)
                                                .transition(.opacity)
                                                }
                                            }
                                            .animation(.easeInOut(duration: 0.3), value: isShowingLock)
                                    }
                                    .toolbar {
                                        ToolbarItem(placement: .primaryAction) {
                                            Button("Not Mine",
                                                   action: { isShowingSheet.toggle() })
                                            .padding(15)
                                        }
                                    }
                                }
                                .presentationDragIndicator(.visible)
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
