//
//  Experience.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import MapKit

class Experience: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var media: [Media] = []
    var coordinate: CLLocationCoordinate2D
    
    init (title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    func addMedia (mediaType: MediaType, url: URL, data: Data? = nil) {
        media.append(Media(mediaType: mediaType, url: url, data: data))
    }
}
