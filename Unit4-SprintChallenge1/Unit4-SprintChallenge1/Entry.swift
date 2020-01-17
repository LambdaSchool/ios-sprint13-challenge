//
//  Entry.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreLocation

enum MediaType: String {
    case image
    case audio
    case video
}

class Entry {

    var title: String?
    let mediaType: MediaType
    var geotag: CLLocationCoordinate2D?

    init(title: String?, mediaType: MediaType, geotag: CLLocationCoordinate2D?) {
        self.title = title
        self.mediaType = mediaType
        self.geotag = geotag
    }
}
