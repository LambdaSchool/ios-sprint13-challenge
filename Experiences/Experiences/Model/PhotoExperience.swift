//
//  PhotoExperience.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MapKit

struct PhotoExperience: ExperienceProtocol {
    var audioFile: URL?
    var photo: Data?
    var date: Date = Date()
    var lastEdit: Date? = nil
    var location: Location
    var title: String
    var body: String?
}
