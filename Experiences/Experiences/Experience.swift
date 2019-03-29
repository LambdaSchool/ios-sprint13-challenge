//
//  Experience.swift
//  Experiences
//
//  Created by Angel Buenrostro on 3/29/19.
//  Copyright © 2019 Angel Buenrostro. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Experience {
    
    var title: String
    var photo: UIImage
    var recording: URL
//    var fileURL: URL? {
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
//
//        return documentDirectory.appendingPathComponent("audioComment.m4a")
//    }
    var geoTag: CLLocationCoordinate2D
    
    init(title: String, photo: UIImage, recording: URL, geoTag: CLLocationCoordinate2D){
        self.title = title
        self.photo = photo
        self.recording = recording
        self.geoTag = geoTag
    }
}
