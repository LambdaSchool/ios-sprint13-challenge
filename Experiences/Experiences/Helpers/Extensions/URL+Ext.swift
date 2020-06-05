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
        let fileURL = documentsDirectory.appendingPathComponent(title).appendingPathExtension("png")
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
    
    static func fetchAudioFromDocumentsDirectory(name: String) -> URL? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        guard let dirPath = paths.first else { return nil }
        let audioURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name).appendingPathExtension("caf")
        return audioURL
    }
    
    static func fetchVideoFromDocumentsDirectory(name: String) -> URL? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        guard let dirPath = paths.first else { return nil }
        let videoURL = URL(fileURLWithPath: dirPath).appendingPathComponent(name).appendingPathExtension("mp4")
        return videoURL
    }
}
