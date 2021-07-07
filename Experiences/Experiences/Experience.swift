//
//  Experience.swift
//  Experiences
//
//  Created by Thomas Cacciatore on 7/12/19.
//  Copyright © 2019 Thomas Cacciatore. All rights reserved.
//

import UIKit
import CoreLocation


class Experience: NSObject {
    var audio: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory  = paths[0]
        return documentsDirectory
    }
    var video: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory  = paths[0]
        return documentsDirectory
    }
    var image: UIImage
    var title: String?
    var location: CLLocationCoordinate2D

    init(image: UIImage, title: String, location: CLLocationCoordinate2D) {
        self.location = location
        self.image = image
        self.title = title
    }
    
}

