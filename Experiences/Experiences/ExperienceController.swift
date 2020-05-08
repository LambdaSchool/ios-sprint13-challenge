//
//  ExperienceController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import Foundation
import CoreLocation

struct Experience {
    var title: String
    let time: Date
    let latitude: Double
    let longitude: Double
    
    // Media
    var audioClips: [URL]
    var videos: [URL]
    var photos: [URL]
}


class ExperienceController {
    private(set) var experiences: [Experience] = []
    
    // MARK: - CRUD
    
    
}
