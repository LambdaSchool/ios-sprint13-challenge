//
//  ExperiencesController.swift
//  MediaProgramming
//
//  Created by Yvette Zhukovsky on 1/18/19.
//  Copyright © 2019 Yvette Zhukovsky. All rights reserved.
//
import MapKit
import Foundation


class ExperiencesController {
    private (set) var experiences: [Experience] = []
func makingExperiences(coordinate: CLLocationCoordinate2D , title: String, image: UIImage, audioURL: URL, videoURL: URL){
 
    
    let exper = Experience(coordinate: coordinate, title: title, image: image, audioURL: audioURL, videoURL: videoURL)
    
   experiences.append(exper)

}
}
