//
//  UserExperienceController.swift
//  UserMediaExperiences
//
//  Created by Austin Cole on 2/22/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation
import MapKit

class UserExperienceController {
    
    //MARK: Non-Private Properties
    var userExperienceArray: [UserExperience]?
    
    //MARK: Non-Private Methods
    func addVideoExperience(userExperience: UserExperience, videoURL: URL) {
        let userExperienceIndex = userExperienceArray?.firstIndex(of: userExperience)
        userExperienceArray?[userExperienceIndex!].videoURL = videoURL
    }
    func createUserExperience(coordinate: CLLocationCoordinate2D) -> UserExperience {
        return UserExperience(audioURL: nil, videoURL: nil, imageData: nil, title: nil, coordinate: coordinate)
        
    }
    func addAudioImageUserExperiences(userExperience: UserExperience, audioURL: URL, imageData: Data, title: String) {
        userExperience.audioURL = audioURL
        userExperience.imageData = imageData
        userExperience.title = title
        userExperienceArray?.append(userExperience)
    }
}
