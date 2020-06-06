//
//  PhotoExperience.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MapKit

class PhotoExperience: NSObject, ExperienceProtocol {
    let id: UUID
    var date: Date
    var lastEdit: Date? = nil
    var location: Location
    var subject: String
    var body: String?
    var audioFile: URL?
    var photo: Data?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        lastEdit: Date? = nil,
        location: Location,
        title: String,
        body: String,
        audioFile: URL?,
        photo: Data?
        ) {

        self.id = id
        self.date = date
        self.lastEdit = lastEdit
        self.location = location
        self.subject = title
        self.body = body
        self.audioFile = audioFile
        self.photo = photo
        super.init()

    }
}
