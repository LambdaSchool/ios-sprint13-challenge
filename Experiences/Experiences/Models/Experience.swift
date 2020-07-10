//
//  Experience.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSCoder {
    let title: String
    let image: Data?
    let audioRecording: URL?
    let location: MKCoordinateSpan?
    
    init(title: String, image: Data?, audioRecording: URL?, location: MKCoordinateSpan?) {
        self.title = title
        self.image = image
        self.audioRecording = audioRecording
        self.location = location
    }
}
