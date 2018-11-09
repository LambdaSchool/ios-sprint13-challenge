//
// Experience.swift
//  Experiences
//
//  Created by Daniela Parra on 11/9/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
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
