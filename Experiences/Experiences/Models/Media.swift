//
//  Media.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum MediaType {
    case audio
    case video
    case image
}

class Media {
    let mediaType: MediaType
    let mediaURL: URL
    let mediaData: Data?
    let date: Date
    
    init (mediaType: MediaType, url: URL, data: Data? = nil, date: Date = Date()) {
        self.mediaType = mediaType
        self.mediaData = data
        self.mediaURL = url
        self.date = date
    }
    
    func play (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        completion(nil)
    }
    
    func pause (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        completion(nil)
    }
    
    func stop (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        completion(nil)
    }
    
    func togglePlayPause (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
        completion(nil)
    }
}
