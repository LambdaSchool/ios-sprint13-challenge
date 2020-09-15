//
//  Experience.swift
//  ExperiencesChallenge
//
//  Created by Ian French on 9/13/20.
//  Copyright © 2020 Ian French. All rights reserved.
//

import Foundation
import MapKit

enum MediaType: String {
    case image
    case audio

}

class Experience: NSObject {

    var experienceTitle: String?
    let mediaType: MediaType
    var geotag: CLLocationCoordinate2D?

    init(title: String?, mediaType: MediaType, geotag: CLLocationCoordinate2D?) {
        self.experienceTitle = title
        self.mediaType = mediaType
        self.geotag = geotag
    }
}

