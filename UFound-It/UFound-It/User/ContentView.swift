//
//  ContentView.swift
//  UFound-It
//
//  Created by Yongye on 11/8/24.
//

import SwiftUI

enum AppTab: String, Hashable {
    case home
    case profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .profile: return "profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home: return "mappin.and.ellipse"
        case .profile: return "person"
        }
    }
}

struct ContentView: View {

    @State private var selectedTab: AppTab = .home

    @State private var authViewModel: AuthViewModel = .init()

    var body: some View {

        Group {

            if authViewModel.user == nil {

                LoginView()

            } else {

                TabView(selection: $selectedTab) {
                    Tab(AppTab.home.title, systemImage: AppTab.home.systemImage, value: AppTab.home) {
                        HomeView()
                    }

                    Tab(AppTab.profile.title, systemImage: AppTab.profile.systemImage, value: AppTab.profile) {
                        UserProfileView()
                    }

                }
                .tint(.UmassRed)
                .environment(authViewModel)
            }

        }
    }
}

#Preview {
    ContentView()
        .environment(AuthViewModel())
}
