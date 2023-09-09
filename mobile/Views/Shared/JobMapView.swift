//
//  JobMapsView.swift
//  mobile
//
//  Created by cb on 10.09.23.
//

import SwiftUI
import MapKit
import CoreLocation

import SwiftUI
import MapKit

struct JobMapView: View {
    @State private var region: MKCoordinateRegion
    let job: Job
    private let locationManager = CLLocationManager()

    init(job: Job) {
        self.job = job
        _region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: job.latitude, longitude: job.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
    }

    var body: some View {
        Map(coordinateRegion: .constant(region), showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: [job]) { job in
            MapPin(coordinate: CLLocationCoordinate2D(latitude: job.latitude, longitude: job.longitude), tint: .blue)
        }
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            if let userLocation = locationManager.location?.coordinate {
                region.center = userLocation
            }
        }
    }

    private func regionBounding(coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion? {
        guard !coordinates.isEmpty else { return nil }

        let maxLat = coordinates.map { $0.latitude }.max()!
        let minLat = coordinates.map { $0.latitude }.min()!
        let maxLon = coordinates.map { $0.longitude }.max()!
        let minLon = coordinates.map { $0.longitude }.min()!

        let center = CLLocationCoordinate2D(
            latitude: (maxLat + minLat) / 2,
            longitude: (maxLon + minLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.2,
            longitudeDelta: (maxLon - minLon) * 1.2
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}
