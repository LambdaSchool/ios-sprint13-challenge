//
//  URL+Ext.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import Foundation

extension URL {
    static func makeNewImageURL(with title: String) -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Could not load documents directory") }
        let fileURL = documentsDirectory.appendingPathComponent(title).appendingPathExtension("jpeg")
        return fileURL
    }
    
    static func makeNewAudioURL(with title: String) -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Could not load documents directory") }
        let fileURL = documentsDirectory.appendingPathComponent(title).appendingPathExtension("caf")
        return fileURL
    }
    
    static func makeNewVideoURL(with title: String) -> URL {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Could not load documents directory") }
        let fileURL = documentsDirectory.appendingPathComponent(title).appendingPathExtension("mp4")
        return fileURL
    }
}
