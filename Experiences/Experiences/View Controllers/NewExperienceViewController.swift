//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/4/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class NewExperienceViewController: UIViewController {

    // MARK: - Outlets & Properties

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var audioContainerView: UIView!
    @IBOutlet weak var videoContainerView: UIView!
    @IBOutlet weak var audioFileLabel: UILabel!
    @IBOutlet weak var videoFileLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Actions

    @IBAction func photoButtonTapped(_ sender: UIButton) {

    }

    @objc private func tapDismissKeyboard(_ tapGesture: UITapGestureRecognizer) {
        titleTextField.resignFirstResponder()
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }


    // MARK: - Helper Functions

    private func setupUI() {
        [imageView, audioContainerView, videoContainerView].forEach { $0?.layer.cornerRadius = 8 }
        let tapDissmissKeyboard = UITapGestureRecognizer(target: self, action: #selector(tapDismissKeyboard(_:)))
        view.addGestureRecognizer(tapDissmissKeyboard)
    }

}
