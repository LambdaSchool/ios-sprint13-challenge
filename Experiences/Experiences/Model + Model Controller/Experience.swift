//
//  Experience.swift
//  Experiences
//
//  Created by Jason Modisett on 1/18/19.
//  Copyright © 2019 Jason Modisett. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    let image: UIImage?
    let audioURL: URL?
    var videoURL: URL?
    
    init(title: String?, coordinate: CLLocationCoordinate2D, image: UIImage?, audioURL: URL?, videoURL: URL?) {
        self.title = title
        self.coordinate = coordinate
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
    }
    
}
