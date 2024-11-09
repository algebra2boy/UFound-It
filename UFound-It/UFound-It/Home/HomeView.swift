//
//  HomeView.swift
//  UFound-It
//
//  Created by Yongye on 11/8/24.
//

import SwiftUI
import MapKit

struct HomeView: View {

    @State private var cameraPosition: MapCameraPosition = .region(.init(
        center: .ILC,
        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
    ))

    let coordinates: [CLLocationCoordinate2D] = [.ILC, .ISB, .Franklin]

    @State private var presentBottomSheet: Bool = true

    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(coordinates, id: \.self) { coordinate in
                Annotation("Box", coordinate: coordinate) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(.background)
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(.secondary, style: StrokeStyle(lineWidth: 2))
                        Image(systemName: "shippingbox")
                            .padding(5)
                    }
                    .onTapGesture {
                        presentBottomSheet.toggle()
                    }
                }
            }

        }
        .sheet(isPresented: $presentBottomSheet) {
            BuildingDetailView()
//                .presentationDetents([.fraction(0.4)])
//                .presentationDragIndicator(.visible)
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
