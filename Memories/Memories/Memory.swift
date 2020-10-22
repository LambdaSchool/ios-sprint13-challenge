//
//  Memory.swift
//  Memories
//
//  Created by Samantha Gatt on 10/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import MapKit

class Memory: NSObject, MKAnnotation {
    
    init(title: String, image: UIImage, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.image = image
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.coordinate = coordinate
    }
    
    var title: String?
    var image: UIImage
    var audioURL: URL
    var videoURL: URL
    var coordinate: CLLocationCoordinate2D
}
