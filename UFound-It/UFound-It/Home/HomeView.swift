//
//  HomeView.swift
//  UFound-It
//
//  Created by Yongye on 11/8/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let amherst: CLLocationCoordinate2D = .init(latitude: 42.3909, longitude: -72.5257)
}

struct HomeView: View {
    
    @State private var cameraPosition: MapCameraPosition = MapCameraPosition.region(.init(
        center: .amherst,
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))
    
    var body: some View {
        Map(position: $cameraPosition)
    }
}

#Preview {
    HomeView()
}
