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
    let experienceController = ExperienceController.shared
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        for cell in tableView.visibleCells {
            cell.isSelected = false
        }
        print(experienceController.count)
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
