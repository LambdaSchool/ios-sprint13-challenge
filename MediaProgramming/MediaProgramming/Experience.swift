//
//  Experience.swift
//  MediaProgramming
//
//  Created by Yvette Zhukovsky on 1/18/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//

import MapKit
import Foundation

class Experience: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var image: Data
    var audioURL: URL
    var videoURL: URL
    
    init(coordinate: CLLocationCoordinate2D? , title: String, image: Data, audioURL: URL, videoURL: URL){
    
    self.coordinate = coordinate ??  CLLocationCoordinate2D(latitude: -70.0, longitude: -70.0)
    self.title = title
    self.image = image
    self.audioURL = audioURL
    self.videoURL = videoURL
   
    }
}
