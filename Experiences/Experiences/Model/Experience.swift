//
//  Experience.swift
//  Experiences
//
//  Created by Mitchell Budge on 7/12/19.
//  Copyright © 2019 Mitchell Budge. All rights reserved.
//


import Foundation
import CoreLocation
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage?
    var audio: URL?
    var video: URL?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, image: UIImage?, audio: URL?, video: URL?) {
        self.coordinate = coordinate
        self.title = title
        self.image = image
        self.audio = audio
        self.video = video
    }
    
}

