//
//  Experience.swift
//  Experiences
//
//  Created by Claudia Maciel on 7/17/20.
//  Copyright © 2020 thecoderpilot. All rights reserved.
//

import Foundation

class Experience: NSObject {
    let title: String?
    let audioURL: URL?
    
    let longitude: Double
    let latitude: Double
    
    init(title: String, audioURL: URL?, longitude: Double, latitude: Double) {
        self.title = title
        self.audioURL = audioURL
        self.longitude = longitude
        self.latitude = latitude
    }
}
