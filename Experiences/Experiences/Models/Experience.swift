//
//  Experience.swift
//  Experiences
//
//  Created by Vincent Hoang on 7/10/20.
//  Copyright © 2020 Vincent Hoang. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSCoder, MKAnnotation {
    
    let title: String?
    let image: Data?
    let audioRecording: URL?
    
    var coordinate: CLLocationCoordinate2D

    
    init(title: String, image: Data?, audioRecording: URL?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.audioRecording = audioRecording
        self.coordinate = coordinate
    }
    
}
