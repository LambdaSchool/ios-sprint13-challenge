//
//  ExperienceDetailViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/16/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import UIKit

class ExperienceDetailViewController: UIViewController {
    
    var experience: Experience? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let experience = experience, self.isViewLoaded else { return }
        print(experience)
    }
}
