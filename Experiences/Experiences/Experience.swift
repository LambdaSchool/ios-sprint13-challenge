//
//  Experience.swift
//  Experiences
//
//  Created by Michael on 3/13/20.
//  Copyright © 2020 Michael. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var expTitle: String
    var image: UIImage?
    var video: URL?
    var audio: URL?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, image: UIImage?, video: URL?, audio: URL?, coordinate: CLLocationCoordinate2D) {
        self.expTitle = title
        self.image = image
        self.video = video
        self.audio = audio
        self.coordinate = coordinate
    }
}
