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

    var body: some View {

        TabView(selection: $selectedTab) {
            Tab(AppTab.home.title, systemImage: AppTab.home.systemImage, value: AppTab.home) {
                Text("home")
            }

            Tab(AppTab.profile.title, systemImage: AppTab.profile.systemImage, value: AppTab.profile) {
                Text("profile")
            }

        }
    }
}

#Preview {
    ContentView()
}
