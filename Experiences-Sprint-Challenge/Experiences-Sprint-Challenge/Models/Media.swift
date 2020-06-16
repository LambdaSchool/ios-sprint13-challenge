//
//  Media.swift
//  Experiences-Sprint-Challenge
//
//  Created by Jonalynn Masters on 1/17/20.
//  Copyright © 2020 Jonalynn Masters. All rights reserved.
//

import Foundation

//MARK: - Properties
enum MediaType: String, CaseIterable {
    case audio = "Audio"
    case video = "Video"
    case image = "Image"
    static let types: [String] = ["Audio", "Video", "Image"]
}

class Media {
    //MARK: - Properties
    let mediaType: MediaType
    var mediaURL: URL?
    var mediaData: Data?
    let createdDate: Date
    var updatedDate: Date?
    
    //MARK: - View Lifecycle
    init (mediaType: MediaType, url: URL?, data: Data? = nil, date: Date = Date()) {
        self.mediaType = mediaType
        self.mediaData = data
        self.mediaURL = url
        self.createdDate = date
    }
}
