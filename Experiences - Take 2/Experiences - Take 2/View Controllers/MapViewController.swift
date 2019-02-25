import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var location: CLLocationCoordinate2D!
    
    private let locationManager = CLLocationManager()
    
    var experienceController = ExperienceController.shared
    
    var experiences = ExperienceController.shared.experiences
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var secondMapView: MKMapView!
    
    @IBAction func unwindToVC1(segue: UIStoryboardSegue) {}
    
    // Need a known set of experiences
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.requestLocation()
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
        
//        if experienceController.newExperience?.coordinate != nil {
//            //mapView.addAnnotation(location as! MKAnnotation)
//            mapView.addAnnotation(experienceController.newExperience?.coordinate as! MKAnnotation)
//        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let experience = annotation as? Experience else { return nil }
        
        // Get a view
        let experienceView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnnotationView", for: experience) as! MKMarkerAnnotationView
        
        experienceView.glyphText = experienceController.newExperience?.title
        
        return experienceView
    }

//    
//    @IBAction func save(_ sender: Any) {
//        let newExperience = Experience(title: nil, audio: nil, video: nil, image: nil, coordinate: location)
//        
//        experiences.append(newExperience)
//    }
    
    @IBAction func createExperience(_ sender: Any) {
        
        let newExperience = Experience(title: nil, audio: nil, video: nil, image: nil, coordinate: location)
        
        experiences.append(newExperience)
        
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        location = locations.first?.coordinate
        
        if let firstLocation = locations.first {
            print("Location: \(firstLocation)")
            
            experienceController.location = location

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    
    func updateView() {
        
        let annotations = mapView.annotations
        
        mapView.removeAnnotations(annotations)
        
        
        if experienceController.newExperience != nil {
            
            mapView.addAnnotation(experienceController.newExperience!)
            
            let newPin = MKPointAnnotation()
            if let firstCoordinate = experienceController.newExperience?.coordinate {
                newPin.coordinate = firstCoordinate
            }
            if let annotationText = experienceController.newExperience?.title {
                newPin.title = annotationText
            }
            mapView.addAnnotation(newPin)
            
        }
    }
}

