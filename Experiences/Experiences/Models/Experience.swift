//
//  Experience.swift
//  Experiences
//
//  Created by Dillon McElhinney on 2/22/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject {
    
    // MARK: - Properties
    let experienceTitle: String
    let audioURL: URL
    let videoURL: URL
    let imageURL: URL
    let geotag: CLLocationCoordinate2D?
    
    // MARK: - Initializers
    init(title: String, audioURL: URL, videoURL: URL, imageURL: URL, geotag: CLLocationCoordinate2D? = nil) {
        self.experienceTitle = title
        self.audioURL = audioURL
        self.videoURL = videoURL
        self.imageURL = imageURL
        self.geotag = geotag
    }
}

// MARK: - MK Annotation
extension Experience: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return geotag ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    var title: String? {
        return experienceTitle
    }
}
