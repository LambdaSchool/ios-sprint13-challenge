//
//  Posts.swift
//  Truthly
//
//  Created by Ezra Black on 6/7/20.
//  Copyright © 2020 Casanova Studios. All rights reserved.
//

import Foundation
import CoreLocation

enum MediaType: String {
    case image
    case audio
    case video
}

class Post: NSObject {

    var postTitle: String?
    let mediaType: MediaType
    var geotag: CLLocationCoordinate2D?

    init(title: String?, mediaType: MediaType, geotag: CLLocationCoordinate2D?) {
        self.postTitle = title
        self.mediaType = mediaType
        self.geotag = geotag
    }
}
