//
//  Experience.swift
//  Experiences
//
//  Created by Jessie Ann Griffin on 5/15/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import Foundation
import MapKit

enum MediaType {
    case image
    case audio
    case video
}

class Experience: NSObject {
    let experienceTitle: String
    let geotag: CLLocationCoordinate2D
    let media: [MediaType]
    
    init(title: String, geotag: CLLocationCoordinate2D, media: [MediaType]) {
        self.experienceTitle = title
        self.geotag = geotag
        self.media = media
    }
}

//extension Experience: MKAnnotation {
//    var coordinate: CLLocationCoordinate2D {
//        <#code#>
//    }
//    
//    var title: String? {
//        
//    }
//    
//}
