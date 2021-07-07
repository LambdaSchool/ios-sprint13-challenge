import UIKit
import MapKit

class ExperienceController {

    static let shared = ExperienceController()
    private init () {}
    
    var newExperience: Experience?
    
    var experiences: [Experience] = []
    
    var location: CLLocationCoordinate2D!
    
    func createExperience(with title: String?, audio: URL?, video: URL?, image: UIImage?, coordinate: CLLocationCoordinate2D) -> Experience {
        
        var newExperience = Experience(title: title, audio: audio, video: video, image: image, coordinate: coordinate)
        
        return newExperience
    }
    
    func add(experience: Experience) {
        experiences.append(experience)
    }
    
    func addVideo(to experience: Experience, video: URL?) {
        experience.video = video
    }
    
    
    
}
