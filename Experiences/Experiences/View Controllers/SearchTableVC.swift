//
//  SearchTableVC.swift
//  Experiences
//
//  Created by Jeffrey Santana on 10/4/19.
//  Copyright © 2019 Lambda. All rights reserved.
//

import UIKit
import MapKit

protocol SearchTableVCDelegate {
	func didSelectLocation(_ location: CLLocation)
}

class SearchTableVC: UITableViewController {

	// MARK: - IBOutlets
	
	@IBOutlet weak var searchBar: UISearchBar!
	
	// MARK: - Properties
	
	var mapView: MKMapView?
	var delegate: SearchTableVCDelegate?
	private let searchRequest = MKLocalSearch.Request()
	private var searchItems = [MKMapItem]()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchBar.delegate = self
		searchBar.becomeFirstResponder()
	}
	
	// MARK: - IBActions
	
	
	// MARK: - Helpers
	
	private func searchForRequest() {
		guard let mapView = mapView, searchRequest.naturalLanguageQuery != nil else { return }
		
		searchRequest.region = mapView.region
		searchRequest.resultTypes = .pointOfInterest
		let search = MKLocalSearch(request: searchRequest)
		
		search.start { response, error in
			guard let response = response else {
				print("Error: \(error?.localizedDescription ?? "Unknown error").")
				return
			}

			self.searchItems = response.mapItems
			self.tableView.reloadData()
		}
	}
	
	private func distanceUserIs(from location: MKMapItem) -> String {
		guard let userCoordinate = mapView?.userLocation.coordinate else { return "0" }
		let userLocation = CLLocation(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude)
		let destination = CLLocation(latitude: location.placemark.coordinate.latitude, longitude: location.placemark.coordinate.longitude)
		
		let MILES_CONVERSION = 1609.344
		let distance = userLocation.distance(from: destination) / MILES_CONVERSION
		
		return String(format: "%.1f", distance)
	}
	
	// MARK: - Table view data source
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		searchItems.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MapSearchCell", for: indexPath)
		let searchItem = searchItems[indexPath.row]
		
		cell.textLabel?.text = searchItem.name
		cell.detailTextLabel?.text = "\(searchItem.pointOfInterestCategory?.rawValue ?? "Location") ~ \(distanceUserIs(from: searchItem)) mi"
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let searchItem = searchItems[indexPath.row]
		let location = CLLocation(latitude: searchItem.placemark.coordinate.latitude, longitude: searchItem.placemark.coordinate.longitude)
		
		delegate?.didSelectLocation(location)
		dismiss(animated: true, completion: nil)
	}
}

extension SearchTableVC: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, text != "" else { return }
		searchRequest.naturalLanguageQuery = text
		searchForRequest()
	}
}
