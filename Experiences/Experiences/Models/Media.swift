//
//  Media.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/1/19.
//  Copyright © 2019 Lambda School. All rights reserved.
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
    
    
//TODO: - Work on this approach later
//    func play (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
//        completion(nil)
//        switch self.mediaType {
//        case .audio:
//            break
//        case .video:
//            break
//        case .image:
//            break
//        }
//    }
//
//    func pause (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
//        completion(nil)
//    }
//
//    func stop (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
//        completion(nil)
//    }
//
//    func togglePlayPause (completion: @escaping (_ error: Error?) -> Void = { _ in }) {
//        completion(nil)
//    }
}
