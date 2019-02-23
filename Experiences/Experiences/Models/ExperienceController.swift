
import UIKit

class ExperienceController {
    
    var experience: Experience?
    
    var experiences: [Experience] = []
    
    func createExperience(with title: String, audio: URL?, video: URL?, image: UIImage?, geotag: String?) -> Experience {
        
        var newExperience = Experience(title: title, audio: audio, video: video, image: image, geotag: geotag)
        
        return newExperience
    }
    
    func add(experience: Experience) {
        experiences.append(experience)
    }
    
    func addVideo(to experience: Experience, video: URL?) {
        experience.video = video
    }
    
    
    
}
