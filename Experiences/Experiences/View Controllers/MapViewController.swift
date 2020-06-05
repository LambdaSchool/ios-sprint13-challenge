//
//  MapViewController.swift
//  Experiences
//
//  Created by Sal B Amer on 5/15/20.
//  Copyright © 2020 Sal B Amer. All rights reserved.
//

import UIKit
import MapKit

extension String {
  static let annotationReuseIdentifier = "ExperienceAnnotationView"
}

class MapViewController: UIViewController {
  
  var experienceController: ExperienceController?
  private var userTrackingButton: MKUserTrackingButton!
  private let locationManager = CLLocationManager()

  //MARK: Outlets
  @IBOutlet weak var mapKitView: MKMapView!
  

  override func viewDidLoad() {
    super.viewDidLoad()
    userTrackingButton = MKUserTrackingButton(mapView: mapKitView)
    userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(userTrackingButton)
    
    NSLayoutConstraint.activate([
      userTrackingButton.leadingAnchor.constraint(equalTo: mapKitView.leadingAnchor, constant: 20),
      mapKitView.bottomAnchor.constraint(equalTo: userTrackingButton.bottomAnchor, constant: 20)
      
    ])
    
    mapKitView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: .annotationReuseIdentifier)
    mapKitView.delegate = self
    mapKitView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "EntryView")
    fetchEntries()
  }
  
  private func fetchEntries() {
    guard let entries = experienceController?.experiences else { return }

      DispatchQueue.main.async {
          self.mapKitView.addAnnotations(entries)

          guard let entry = entries.first else { return }

          let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
          let region = MKCoordinateRegion(center: entry.coordinate, span: span)
          self.mapKitView.setRegion(region, animated: true)
      }
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
  //MARK: Actions
  
  @IBAction func saveBtnPressed(_ sender: UIBarButtonItem) {
    //TODO: Pass recorded data to tableview
    performSegue(withIdentifier: "mapToRootControllerSegue", sender: nil)
  }
  
}


extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let _ = annotation as? Experience else {
            fatalError("Only Entries are supported right now")
        }

        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "EntryView") as? MKMarkerAnnotationView else {
            fatalError("Missing registered map annotation view")
        }

        return annotationView
    }
}
