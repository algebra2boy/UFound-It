//
//  HomeView.swift
//  UFound-It
//
//  Created by Yongye on 11/8/24.
//

import SwiftUI
import MapKit

struct HomeView: View {

    @State private var homeViewModel: HomeViewModel = .init()

    @State private var cameraPosition: MapCameraPosition = .region(.init(
        center: .ILC,
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))

    @State private var currentDetent: PresentationDetent = .fraction(0.465)

    let coordinates: [CLLocationCoordinate2D] = [.ILC, .ISB, .Franklin]

    @State private var presentBottomSheet: Bool = false

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(homeViewModel.boxLocations, id: \.self) { location in
                Annotation("L&F", coordinate: .init(latitude: location.lat, longitude: location.long)) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.background)
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(.secondary, style: StrokeStyle(lineWidth: 2))
                        Image(systemName: "shippingbox")
                            .padding(5)
                    }
                    .onTapGesture {
                        homeViewModel.selectedLocation = location
                        presentBottomSheet.toggle()
                    }
                }
            }

        }
        .task {
            await homeViewModel.fetchAllLocations()
        }
        .sheet(isPresented: $presentBottomSheet) {

            BuildingDetailView(present: $presentBottomSheet, detent: $currentDetent, buildingName: homeViewModel.selectedLocation?.location ?? "Unknown building")
                .presentationDetents([.fraction(0.465), .fraction(0.7), .large], selection: $currentDetent)
                .presentationDragIndicator(.visible)
                .presentationCornerRadius(20)
        }
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {}
extension CLLocationCoordinate2D: @retroactive Hashable {
    static let ILC: Self = .init(latitude: 42.3909, longitude: -72.5257)
    static let LGRC: Self = .init(latitude: 42.340382, longitude: -72.496819)
    static let ISB: Self = .init(latitude: 42.3926, longitude: -72.5250)
    static let Franklin: Self = .init(latitude: 42.3893, longitude: -72.5225)

    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}

#Preview {
    HomeView()
}
