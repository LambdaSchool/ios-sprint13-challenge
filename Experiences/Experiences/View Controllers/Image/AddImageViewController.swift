//
//  AddImageViewController.swift
//  Experiences
//
//  Created by David Wright on 5/17/20.
//  Copyright © 2020 David Wright. All rights reserved.
//

import UIKit

protocol AddMediaViewControllerDelegate {
    func didAddMedia(mediaType: MediaType, url: URL)
}

class AddImageViewController: UIViewController {

    // MARK: - Properties

    var delegate: AddMediaViewControllerDelegate?
    
    // MARK: - View Controller Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
}
