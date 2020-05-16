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

class Experience: NSObject, Decodable {
    var experienceTitle: String
    
    
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
