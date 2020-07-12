//
//  ExperienceController.swift
//  Experiences
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
    let locationManager = CLLocationManager()
    let persistenceController = PersistenceController()
    
    //MARK: - Life Cycle -
    init() {
        updateExperiences()
        locationManager.requestLocation()
        addGPC()
    }
    
    
    //MARK: - Actions -
    mutating func addTitle(_ title: String) {
        draftTitle = title
    }
    
    mutating func addCaption(_ caption: String) {
        draftCaption = caption
    }
    
    mutating func addGPC() {
        if let coordinate = locationManager.location?.coordinate {
            draftLocation = coordinate
        }
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
        persistenceController.saveExperiences(experiences)
    }
    
    mutating private func updateExperiences() {
        let experiences = persistenceController.loadExperiences()
        self.experiences = experiences
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

