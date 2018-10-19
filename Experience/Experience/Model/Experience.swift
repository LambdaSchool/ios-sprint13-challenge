//
//  Expereince.swift
//  Experience
//
//  Created by Simon Elhoej Steinmejer on 19/10/18.
//  Copyright © 2018 Simon Elhoej Steinmejer. All rights reserved.
//

import Foundation

class Experience: NSObject
{
    var title: String?
    var imageUrlString: String?
    var videoUrlString: String?
    var audioUrlString: String?
    
    init(dictionary: [String: Any])
    {
        self.title = dictionary["title"] as? String
        self.imageUrlString = dictionary["imageUrlString"] as? String
        self.videoUrlString = dictionary["videoUrlString"] as? String
        self.audioUrlString = dictionary["audioUrlString"] as? String
    }
}
