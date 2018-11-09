//
//  Experience.swift
//  Experiences
//
//  Created by Ilgar Ilyasov on 11/9/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var audioURL: URL
    var videoURL: URL
    var imageData: Data
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, audioURL: URL, videoURL: URL, imageData: Data, coordinate: CLLocationCoordinate2D? = nil) {
        self.title = title
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.imageData = imageData
        self.coordinate = coordinate ?? CLLocationCoordinate2D(latitude: 100.0, longitude: 100.0)
    }
}
