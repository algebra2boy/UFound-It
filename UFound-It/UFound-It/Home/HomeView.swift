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

    @State private var presentBottomSheet: Bool = false

    var body: some View {
        Map(position: $cameraPosition) {
            Annotation("Box", coordinate: .ILC) {
                ZStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.secondary, lineWidth: 2)
                    Image(systemName: "shippingbox")
                        .padding(5)
                }
                .onTapGesture {
                    presentBottomSheet.toggle()
                    print("i have been tapped")
                }
            }
            //            .annotationTitles(.hidden)

        }
        .sheet(isPresented: $presentBottomSheet) {
            Text("Hello, World!")
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
    }
}

extension CLLocationCoordinate2D {
    static let ILC: Self = .init(latitude: 42.3909, longitude: -72.5257)
    static let LGRC: Self = .init(latitude: 42.340382, longitude: -72.496819)
    static let StudentUnion: Self = .init(latitude: 42.391155, longitude: -72.526711)

    static let coordinates: [Self] = [.LGRC, .StudentUnion]
}

#Preview {
    HomeView()
}
