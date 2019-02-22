//
//  UserExperienceController.swift
//  UserMediaExperiences
//
//  Created by Austin Cole on 2/22/19.
//  Copyright © 2019 Austin Cole. All rights reserved.
//

import Foundation

class UserExperienceController {
    
    //MARK: Non-Private Properties
    var userExperienceArray: [UserExperience]?
    
    //MARK: Non-Private Methods
    func addVideoExperience(userExperience: UserExperience, videoURL: URL) {
        let userExperienceIndex = userExperienceArray?.firstIndex(of: userExperience)
        userExperienceArray?[userExperienceIndex!].videoURL = videoURL
    }
    func createUserExperience(audioURL: URL, imageData: Data, title: String) {
        return UserExperience(audioURL: audioURL, videoURL: nil, imageData: imageData, title: title, coordinate: <#T##CLLocationCoordinate2D#>)
    }
}
