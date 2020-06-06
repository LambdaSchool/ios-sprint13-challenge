//
//  Experience.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation
import MapKit

class Experience: NSObject, ExperienceProtocol {
    let id: UUID
    let date: Date
    var lastEdit: Date?
    var location: Location
    var subject: String
    var body: String?
    var audioFile: URL?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        lastEdit: Date? = nil,
        location: Location,
        title: String,
        body: String,
        audioFile: URL?
        ) {

        self.id = id
        self.date = date
        self.lastEdit = lastEdit
        self.location = location
        self.subject = title
        self.body = body
        self.audioFile = audioFile
        super.init()

    }
}

struct Location: Codable {
    var latitude: Double
    var longitude: Double

    var clLocationRep: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
