//
//  ExperienceController.swift
//  ExperiencesWorkingDraft
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


struct ExperienceController: TextAdderDelegate {
    //MARK: - Properties -
    var draftTitle: String?
    var draftCaption: String?
    var draftVideo: URL?
    var draftPhoto: UIImage?
    var draftAudio: URL?
    var draftLocation: CLLocationCoordinate2D?
    var experiences: [Experience] = []
    
    
    //MARK: - Life Cycle -
    //TODO: Init experiences from user defaults
    
    
    
    
    //MARK: - Actions -
    mutating func addTitle(_ title: String) {
        draftTitle = title
    }
    
    mutating func addCaption(_ caption: String) {
        draftCaption = caption
    }
    
    mutating func addGPC(_ lat: Double, _ lon: Double) {
        //TODO: figure out how to get current corrdinates and set lat and long
    }
    
    mutating func createExperience() {
        guard let title = draftTitle,
            let location = draftLocation else { return }
        
        experiences.append(Experience(title: title,
                                      caption: draftCaption,
                                      video: draftVideo,
                                      photo: draftPhoto,
                                      audio: draftAudio,
                                      location: location))
        //TODO: Save experiences to user defaults
    }
}


extension ExperienceController: PhotoAdderDelegate {
    mutating func addPhoto(_ photo: UIImage) {
        draftPhoto = photo
    }
}


extension ExperienceController: AudioAdderDelegate {
    mutating func addAudio(_ audio: URL) {
        draftAudio = audio
    }
}


extension ExperienceController: VideoAdderDelegate {
    mutating func addVideo(_ video: URL) {
        draftVideo = video
    }
}
