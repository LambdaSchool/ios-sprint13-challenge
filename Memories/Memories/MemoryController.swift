//
//  MemoryController.swift
//  Memories
//
//  Created by Samantha Gatt on 10/19/18.
//  Copyright © 2018 Samantha Gatt. All rights reserved.
//

import Foundation
import MapKit

class MemoryController {
    
    static let shared = MemoryController()
    
    var memories: [Memory] = []
    
    func addMemory(title: String, image: UIImage, audioURL: URL, videoURL: URL, coordinate: CLLocationCoordinate2D) {
        let memory = Memory(title: title, image: image, audioURL: audioURL, videoURL: videoURL, coordinate: coordinate)
        memories.append(memory)
    }
}
