//
//  ClaimSheet.swift
//  UFound-It
//
//  Created by Main Admin on 11/9/24.
//

import SwiftUI

struct ClaimSheet: View {
    
    @Environment(HomeViewModel.self) private var homeViewModel: HomeViewModel
    
    @Binding var isShowingSheet: Bool
    @Binding var isShowingLock: Bool
    
    @Binding var isPressed: Bool
    @Binding var isClaimed: Bool
    
    
    
    var body: some View {
        
        
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
                    Task {
//                        homeViewModel.changeClaim(with: String, email: T##String)
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
        
    }
}

//#Preview {
//    ClaimSheet(isShowingSheet, isShowingLock, isPressed, isClaimed)
//}
