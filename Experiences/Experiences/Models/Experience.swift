//
//  Experience.swift
//  Experiences
//
//  Created by Jake Connerly on 11/1/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit
import CoreLocation

class Experience: NSObject {
    let id: String
    let title: String
    let image: Data
    let audioCommentURL: String
    var geotag: CLLocationCoordinate2D?
    let timestamp: Date
    
    init(id: String = UUID().uuidString, title: String, image: Data, audioCommentURL: String, geotag: CLLocationCoordinate2D?, timestamp: Date = Date()) {
        self.id = id
        self.title = title
        self.image = image
        self.audioCommentURL = audioCommentURL
        self.geotag = geotag
        self.timestamp = timestamp
    }
}
