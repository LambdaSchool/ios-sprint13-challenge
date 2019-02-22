//
//  Experience.swift
//  Sprint13
//
//  Created by Sergey Osipyan on 2/22/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: UIImage
    var audioURL: URL
    var videoURL: URL
    
    init(title: String, image: UIImage, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.coordinate = coordinate
    }
    
}
