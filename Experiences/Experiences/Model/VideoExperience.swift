//
//  VideoExperience.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MapKit

struct VideoExperience: ExperienceProtocol {
    var date: Date = Date()
    var lastEdit: Date? = nil

    var location: CLLocationCoordinate2D

    var title: String
    var body: String?

    var audioFile: Data?

    var videoFile: Data?
}
