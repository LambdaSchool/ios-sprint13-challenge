//
//  Experience.swift
//  Experiences
//
//  Created by Victor  on 7/12/19.
//  Copyright © 2019 Victor . All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class Experience: NSObject {
    var experienceTitle: String?
    var audioURL: URL?
    var videoURL: URL?
    var image: UIImage?
    var geotag: CLLocationCoordinate2D?
}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        guard let geotag = self.geotag else { return kCLLocationCoordinate2DInvalid }
        
        return geotag
    }
    
    var title: String? {
        return self.experienceTitle
    }
}

