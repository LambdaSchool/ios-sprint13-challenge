//
//  Post.swift
//  MyExperiences
//
//  Created by Kelson Hartle on 7/10/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import FirebaseAuth
import MapKit

enum MediaType: String {
    case image
    case video
}

class Post: NSObject {
    
    
    // MARK: - Properties
    var mediaURL: URL
    let mediaType: MediaType
    let author: Author
    let timestamp: Date
    var comments: [Comment]
    var id: String?
    var ratio: CGFloat?
    var geotag: CLLocationCoordinate2D?
    var longitude: Double?
    var latitude: Double?
    
    var title: String? {
        return comments.first?.text
    }
    
    static private let mediaKey = "media"
    static private let ratioKey = "ratio"
    static private let mediaTypeKey = "mediaType"
    static private let authorKey = "author"
    static private let commentsKey = "comments"
    static private let timestampKey = "timestamp"
    static private let idKey = "id"
    
    
    init(title: String, mediaURL: URL, ratio: CGFloat? = nil, author: Author, mediaType: MediaType, timestamp: Date = Date()) {
        self.mediaURL = mediaURL
        self.ratio = ratio
        self.mediaType = mediaType
        self.author = author
        self.comments = [Comment(text: title, author: author)]
        self.timestamp = timestamp
    }
    
    init?(dictionary: [String : Any], id: String) {
        guard let mediaURLString = dictionary[Post.mediaKey] as? String,
            let mediaURL = URL(string: mediaURLString),
            let mediaTypeString = dictionary[Post.mediaTypeKey] as? String,
            let mediaType = MediaType(rawValue: mediaTypeString),
            let authorDictionary = dictionary[Post.authorKey] as? [String: Any],
            let author = Author(dictionary: authorDictionary),
            let timestampTimeInterval = dictionary[Post.timestampKey] as? TimeInterval,
            let captionDictionaries = dictionary[Post.commentsKey] as? [[String: Any]] else { return nil }
        
        self.mediaURL = mediaURL
        self.mediaType = mediaType
        self.ratio = dictionary[Post.ratioKey] as? CGFloat
        self.author = author
        self.timestamp = Date(timeIntervalSince1970: timestampTimeInterval)
        self.comments = captionDictionaries.compactMap({ Comment(dictionary: $0) })
        self.id = id
        
        if let lat = dictionary["lat"] as? Double, let lng = dictionary["lng"] as? Double {
            self.geotag = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        }
    }
    
    var dictionaryRepresentation: [String : Any] {
        var dict: [String: Any] = [Post.mediaKey: mediaURL.absoluteString,
                Post.mediaTypeKey: mediaType.rawValue,
                Post.commentsKey: comments.map({ $0.dictionaryRepresentation }),
                Post.authorKey: author.dictionaryRepresentation,
                Post.timestampKey: timestamp.timeIntervalSince1970]
                
        
        guard let ratio = self.ratio else { return dict }
        
        if let coordinate = self.geotag {
            dict["lat"] = coordinate.latitude
            dict["lng"] = coordinate.longitude
        }
        
        dict[Post.ratioKey] = ratio
        
        return dict
    }
}

// MARK: - Extension
extension Post: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return geotag ?? CLLocationCoordinate2D()
    }
    
    var subtitle: String? {
        return author.displayName
    }
}
