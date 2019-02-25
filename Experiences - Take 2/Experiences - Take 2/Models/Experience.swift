
import UIKit
import MapKit

class Experience: NSObject, MKAnnotation {
    
    var title: String?
    var audio: URL?
    var video: URL?
    var image: UIImage?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, audio: URL?, video: URL?, image: UIImage?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.audio = audio
        self.video = video
        self.image = image
        self.coordinate = coordinate
    }
    
}
