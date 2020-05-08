//
//  AddViewController.swift
//  Experiences
//
//  Created by Mark Gerrior on 5/8/20.
//  Copyright © 2020 Mark Gerrior. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    // MARK: - Properites
    var experienceController: ExperienceController?
    var delegate: MapViewController?

    // If this object exists, it's a view/update situation.
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }

    var audioClip: URL?
    var image: URL?
    var videoClip: URL?

    // MARK: - Actions
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        guard let ec = experienceController,
            let delegate = delegate,
            let title = titleTextField.text,
            title.count > 0 else {
            // TODO: Add a dialog saying why you can't save.
            return
        }

        let coordinates = delegate.whereAmI()

        if experience == nil {
            ec.create(title: title,
                      audioClip: audioClip,
                      image: image,
                      videoClip: videoClip,
                      latitude: coordinates.latitude,
                      longitude: coordinates.longitude)
        }

        navigationController?.popViewController(animated: true)
    }

    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Private
    private func updateViews() {
        
    }
}
