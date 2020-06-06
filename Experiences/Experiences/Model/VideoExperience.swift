//
//  VideoExperience.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation
import MapKit

struct VideoExperience: ExperienceProtocol {    var date: Date = Date()
    var lastEdit: Date? = nil
    var location: Location
    var title: String
    var body: String?
    var audioFile: URL?
    var videoFile: URL?
}

func foo() {
    let exp = VideoExperience(date: Date(), lastEdit: nil, location: Location(latitude: 20, longitude: 20), title: "20, 20 baby", body: nil, audioFile: nil, videoFile: nil)
    
}
