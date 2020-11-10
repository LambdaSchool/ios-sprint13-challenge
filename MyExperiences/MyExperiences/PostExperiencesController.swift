//
//  PostExperiencesController.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import MapKit

class PostExperiencesController {
    
    static let shared = PostExperiencesController()
        var posts: [PostExperiences] = []
        var user: String? {
            UserDefaults.standard.string(forKey: "username")
        }

    func createText(with title: String, entry: String, location: CLLocationCoordinate2D) {
        guard let user = user else { return }
        let post = PostExperiences(title: title, author: user, location: location, image: nil, entry: nil, audioURL: nil)
    }
    
    func createAudio(with title: String, audioURL: URL, location: CLLocationCoordinate2D) {
        guard let user = user else { return }
        let post = PostExperiences(title: title, author: user, location: location, image: nil, entry: nil, audioURL: nil)
    }
    
    func createImage(with title: String, image: UIImage, location: CLLocationCoordinate2D) {
        guard let user = user else { return }
        let post = PostExperiences(title: title, author: user, location: location, image: image, entry: nil, audioURL: nil)
    }

    }
