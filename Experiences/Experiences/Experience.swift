//
//  Experience.swift
//  Experiences
//
//  Created by Julian A. Fordyce on 3/29/19.
//  Copyright © 2019 Julian A. Fordyce. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var title: String?
    var audio: URL?
    var image: UIImage?
    var video: URL?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, audio: URL?, video: URL?, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.audio = audio
        self.image = image
        self.video = video
        self.coordinate = coordinate
    }
    
}
