//
//  NewExperienceViewController.swift
//  Experiences
//
//  Created by Hunter Oppel on 6/8/20.
//  Copyright © 2020 LambdaSchool. All rights reserved.
//

import UIKit

protocol NewExperienceDelegate {
    func didAddNewExperience(_ experience: Experience) -> Void
}

class NewExperienceViewController: UIViewController {
    
    var delegate: NewExperienceDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
