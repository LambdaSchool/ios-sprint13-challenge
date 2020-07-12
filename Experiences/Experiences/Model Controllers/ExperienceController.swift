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
import MapKit

class ExperienceController: NSObject, TextAdderDelegate {
    //MARK: - Properties -
    var draftTitle: String? = nil
    var draftCaption: String? = nil
    var draftVideo: URL? = nil
    var draftPhoto: UIImage? = nil
    var draftAudio: URL? = nil
    var draftLocation: CLLocationCoordinate2D? = nil
    var experiences: [Experience] = []
    let locationManager = CLLocationManager()
    let persistenceController = PersistenceController()
    
    //MARK: - Life Cycle -
    override init() {
        super.init()
        locationManager.delegate = self
        updateExperiences()
        locationManager.requestLocation()
        addGPC()
    }
    
    
    //MARK: - Actions -
    func addTitle(_ title: String) {
        draftTitle = title
    }
    
    func addCaption(_ caption: String) {
        draftCaption = caption
    }
    
    func addGPC() {
        if let coordinate = locationManager.location?.coordinate {
            draftLocation = coordinate
        }
    }
    
    func createExperience() {
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
    
    private func updateExperiences() {
        let experiences = persistenceController.loadExperiences()
        self.experiences = experiences
    }
    
}


//MARK: - Extensions -
//MARK: - Delegates -
extension ExperienceController: PhotoAdderDelegate {
    func addPhoto(_ photo: UIImage) {
        draftPhoto = photo
    }
}


extension ExperienceController: AudioAdderDelegate {
    func addAudio(_ audio: URL) {
        draftAudio = audio
    }
}


extension ExperienceController: VideoAdderDelegate {
    func addVideo(_ video: URL) {
        draftVideo = video
    }
}


extension ExperienceController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        addGPC()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            NSLog("Error with location manager: \(error)")
    }
}

