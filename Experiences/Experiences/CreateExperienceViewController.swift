//
//  CreateExperienceViewController.swift
//  Experiences
//
//  Created by Tobi Kuyoro on 08/05/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import Photos
import AVFoundation

class CreateExperienceViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    // MARK: - Properties

    var experienceController: ExperienceController?

    var image: UIImage?
    var audioURL: URL?
    var videoURL: URL?

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - IBActions

    @IBAction func addImageTapped(_ sender: Any) {
    }


    @IBAction func saveButtonTapped(_ sender: Any) {
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
