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
            let title = titleTextField.text,
            title.count > 0 else {
            // TODO: Add a dialog saying why you can't save.
            return
        }

        if experience == nil {
            ec.create(title: title, audioClip: audioClip, image: image, videoClip: videoClip)
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
