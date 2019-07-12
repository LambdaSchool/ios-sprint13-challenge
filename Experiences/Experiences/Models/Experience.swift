//
//  Experience.swift
//  Experiences
//
//  Created by Kobe McKee on 7/11/19.
//  Copyright © 2019 Kobe McKee. All rights reserved.
//

import Foundation
import MapKit


class Experience: NSObject, MKAnnotation {
    
    var title: String?
    var audio: URL?
    var video: URL?
    var image: URL?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, audio: URL?, video: URL?, image: URL?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.audio = audio
        self.video = video
        self.image = image
        self.coordinate = coordinate
    }
    
}
