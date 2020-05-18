//
//  AddVideoViewController.swift
//  Experiences
//
//  Created by David Wright on 5/17/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit
import AVKit

class AddVideoViewController: UIViewController {

    // MARK: - Properties

    private var videoURL: URL?
    var delegate: AddMediaViewControllerDelegate?
    
    // MARK: - IBOutlets
    
    
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let videoURL = videoURL else { return }
        
        delegate?.didSaveMedia(mediaType: .video, to: videoURL)
        navigationController?.popViewController(animated: true)
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
