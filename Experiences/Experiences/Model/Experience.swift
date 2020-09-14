//
//  Experience.swift
//  Experiences
//
//  Created by Morgan Smith on 9/14/20.
//  Copyright © 2020 Morgan Smith. All rights reserved.
//

import UIKit
import MapKit

struct Experiences {
    var experiences: [Experience]
}

class Experience: NSObject {
    var experienceTitle: String
    var geotag: CLLocationCoordinate2D
    var image: UIImage?
    var audio: URL?

    init(experienceTitle: String,
         geotag: CLLocationCoordinate2D,
         image: UIImage,
         audio: URL) {

        self.experienceTitle = experienceTitle
        self.geotag = geotag
        self.image = image
        self.audio = audio
    }

}

extension Experience: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
         geotag
     }

     var title: String? {
         experienceTitle
     }
}
