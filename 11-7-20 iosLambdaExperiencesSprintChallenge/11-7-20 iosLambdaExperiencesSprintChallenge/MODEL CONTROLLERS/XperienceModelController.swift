//
//  XperienceModelController.swift
//  11-7-20 iosLambdaExperiencesSprintChallenge
//
//  Created by BrysonSaclausa on 11/8/20.
//

import Foundation
import MapKit

class XperienceController {
    
    static let shared = XperienceController()
    
    var xperiencePosts: [XperiencePost] = []
    
    func createXperiencePost(with title: String, image: UIImage, audioURL: URL?, location: CLLocationCoordinate2D) {
        
        let xperiencePost = XperiencePost(title: title, mediaType: .image(image), location: location)
        
        xperiencePosts.append(xperiencePost)
        
        print("\(xperiencePost.location)")
        
    }
    
    
    
}
