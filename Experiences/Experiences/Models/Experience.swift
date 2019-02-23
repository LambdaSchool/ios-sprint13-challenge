
import UIKit

class Experience {
    
    var title: String?
    var audio: URL?
    var video: URL?
    var image: UIImage?
    var geotag: String?
    
    init(title: String?, audio: URL?, video: URL?, image: UIImage?, geotag: String?) {
        self.title = title
        self.audio = audio
        self.video = video
        self.image = image
        self.geotag = geotag
    }
    
}
