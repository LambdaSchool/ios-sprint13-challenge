//
//  Post.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import MapKit

enum MediaType: String {
    case image
    case video
}

class Post {

    
    var videoURL: URL?
    var audioURL: URL?
    let image: UIImage?
    let timestamp: Date
    var id: String?
    var ratio: CGFloat?
    let latitude: Double?
    let longitude: Double?
    var title: String
    let note: String?
    
    static private let mediaKey = "media"
    static private let ratioKey = "ratio"
    static private let mediaTypeKey = "mediaType"
    static private let titleKey = "title"
    static private let timestampKey = "timestamp"
    static private let idKey = "id"
    static private let latitudeKey = "latitude"
    static private let longitudeKey = "longitude"
    static private let noteKey = "note"
    
    
    init(title: String, image: UIImage?, videoURL: URL?, audioURL: URL?, ratio: CGFloat? = nil, timestamp: Date = Date(), latitude: Double?, longitude: Double?, note: String?) {
        self.title = title
        self.videoURL = videoURL
        self.audioURL = audioURL
        self.ratio = ratio
        self.image = image
        self.timestamp = timestamp
        self.latitude = latitude
        self.longitude = longitude
        self.note = note
    }
    

}
