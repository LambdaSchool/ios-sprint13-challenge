//
//  Experience.swift
//  Experiences
//
//  Created by brian vilchez on 2/14/20.
//  Copyright © 2020 brian vilchez. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class Experience: NSObject {
    let name: String
    let image: UIImage?
    let audioRecording: URL?
    let videoRecording: URL?
    let location: CLLocationCoordinate2D?
    
    
    required init(title: String, image: UIImage?, audioRecording: URL?, videoRecording: URL?, location: CLLocationCoordinate2D?) {
        self.name = title
        self.image = image
        self.audioRecording = audioRecording
        self.videoRecording = videoRecording
        self.location = location
        super.init()
    }
    
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let location = self.location else { return CLLocationCoordinate2D()}
        return CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
    
    var title: String? {
        return name
    }
    
    
}
