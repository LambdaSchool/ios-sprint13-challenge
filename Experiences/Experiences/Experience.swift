//
//  Experience.swift
//  Experiences
//
//  Created by Moin Uddin on 11/9/18.
//  Copyright © 2018 Moin Uddin. All rights reserved.
//

import Foundation
import MapKit


class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var videoURL: URL
    var audioURL: URL
    var imageURL: URL
    
    init(title: String, coordinate: CLLocationCoordinate2D, videoURL: URL, audioURL: URL, imageURL: URL) {
        self.title = title
        self.coordinate = coordinate
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.imageURL = imageURL
    }
    

}
