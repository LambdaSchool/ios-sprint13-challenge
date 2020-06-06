//
//  ViewController.swift
//  Experiences
//
//  Created by Kenny on 6/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit
import MapKit

class MainMenuViewController: UIViewController {
    // MARK: - Properties -
    private let experienceController = ExperienceController.shared
    private let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)

    private let markerID = "ExperienceView"
    private let cellID = "MenuCell"

    private let menuArray = [
        UIImage.NamedImage.video,
        UIImage.NamedImage.photo,
        UIImage.NamedImage.story
    ]

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: markerID)
        self.mapView.addAnnotations(experienceController.videoExperiences)
        self.mapView.addAnnotations(experienceController.photoExperiences)
        self.mapView.addAnnotations(experienceController.storyExperiences)
        let firstAvailable =
        experienceController.videoExperiences.first ??
        experienceController.photoExperiences.first ??
            experienceController.storyExperiences.first
        guard let firstExperience = firstAvailable as? ExperienceProtocol else { return }
        //zoom level
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)

        let region = MKCoordinateRegion(center: firstExperience.location.clLocationRep, span: coordinateSpan)
        self.mapView.setRegion(region, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        for cell in tableView.visibleCells {
            cell.isSelected = false
        }
        setupMapView()
    }

}

extension MainMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell,
            let title = cell.title
        else { return }
        performSegue(withIdentifier: "\(title)Segue", sender: nil)
    }
}

extension MainMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MenuTableViewCell else {
            fatalError("check cell ID stoobid")
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = .blue
        cell.selectedBackgroundView = backgroundView
        //Locale: nil is necessary for the image/title/segue pattern to work properly in different locales
        cell.title = menuArray[indexPath.row].rawValue.capitalized(with: nil)
        return cell
    }
}

extension MainMenuViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var markerAnnotation: MKMarkerAnnotationView?

        switch annotation {

        case is Experience:
            guard let experience = annotation as? Experience else {
                fatalError("Unkown, should be covered by switch here.")
            }

            markerAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: markerID, for: experience) as? MKMarkerAnnotationView

            markerAnnotation?.markerTintColor = .systemRed

        case is PhotoExperience:
            guard let experience = annotation as? PhotoExperience else {
                fatalError("Unkown, should be covered by switch here.")
            }

            markerAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: markerID, for: experience) as? MKMarkerAnnotationView

            markerAnnotation?.markerTintColor = .systemGreen
        case is VideoExperience:
            guard let experience = annotation as? VideoExperience else {
                fatalError("Unkown, should be covered by switch here.")

            }
            markerAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: markerID, for: experience) as? MKMarkerAnnotationView

            markerAnnotation?.markerTintColor = .systemOrange

        default:
            break
        }

//        //TODO: Callout
//        markerAnnotation.canShowCallout = true
//        //TODO: Create detailView:
//        let detailView = QuakeDetailView()
//        detailView.quake = experience
//        markerAnnotation.detailCalloutAccessoryView = detailView

        return markerAnnotation
    }
}
