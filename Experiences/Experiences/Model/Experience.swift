//
//  Experience.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation
import MapKit

struct Experience: ExperienceProtocol {
    let id: UUID = UUID()
    let date: Date = Date()
    var lastEdit: Date? = nil
    var location: Location
    var title: String
    var body: String?
    var audioFile: URL?
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double

    var clLocationRep: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
