//
//  Experience.swift
//  Experiences
//
//  Created by Joshua Rutkowski on 5/17/20.
//  Copyright © 2020 Josh Rutkowski. All rights reserved.
//

import Foundation

class Experience: NSObject, Codable {
    
    let name: String
    let id: String = UUID().uuidString
    let date: Date = Date()
    let latitude: Double
    let longitude: Double
    var videoExtension: String
    var videoURL: URL?
    let audioExtension: String
    var audioURL: URL?
    var photoExtension: String
    var photoURL: URL?
}
