//
//  Experience.swift
//  Experiences
//
//  Created by Isaac Lyons on 12/6/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var imageURL: URL?
    var audioURL: URL?
    
    init(title: String, coordinate: CLLocationCoordinate2D, imageURL: URL? = nil, audioURL: URL? = nil) {
        self.title = title
        self.imageURL = imageURL
        self.audioURL = audioURL
        self.coordinate = coordinate
    }
}
