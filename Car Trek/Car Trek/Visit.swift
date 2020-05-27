//
//  Visit.swift
//  Car Trek
//
//  Created by Christy Hicks on 5/17/20.
//  Copyright © 2020 Knight Night. All rights reserved.
//

import UIKit
import MapKit

class Visit {
    var name: String
    var location: CLLocationCoordinate2D
    var photo: UIImage?
    var audioRecordingURL: URL?
    var videoRecordingURL: URL?
    
    init(name: String, location: CLLocationCoordinate2D, photo: UIImage?, audioURL: URL?, videoURL: URL?) {
        self.name = name
        self.location = location
        self.photo = photo
        self.audioRecordingURL = audioURL
        self.videoRecordingURL = videoURL
    }
}
