//
//  ExperienceController.swift
//  ios-sprint-challenge13
//
//  Created by David Doswell on 10/19/18.
//  Copyright © 2018 David Doswell. All rights reserved.
//

private var experienceList = "experiencePList"

import Foundation

private(set) var experiences: [Experience] = []

func createExperience(with title: String, image: URL, audio: URL, video: URL) {
    
    let experience = Experience(title: title, image: image, audio: audio, video: video)
    experiences.append(experience)
    encode()
}

var url : URL? {
    let fileManager = FileManager()
    let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    return docDirectory.appendingPathComponent(experienceList)
}

func encode() {
    do {
        guard let url = url else { return }
        
        let encoder = PropertyListEncoder()
        let experienceData = try encoder.encode(experiences)
        try experienceData.write(to: url)
    } catch {
        NSLog("Error encoding: \(error)")
    }
}

func decode() {
    let fileManager = FileManager()
    do {
        guard let url = url, fileManager.fileExists(atPath: url.path) else { return }
        
        let experienceData = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        let decodedExperiences = try decoder.decode([Experience].self, from: experienceData)
        experiences = decodedExperiences
    } catch {
        NSLog("Error decoding: \(error)")
    }
}
