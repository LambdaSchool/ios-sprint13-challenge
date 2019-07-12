//
//  ExperiencesViewController.swift
//  Experiences
//
//  Created by Sameera Roussi on 7/12/19.
//  Copyright © 2019 Sameera Roussi. All rights reserved.
//

import UIKit

class ExperiencesViewController: UIViewController {

    // MARK: - View states
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar
        self.navigationController?.navigationBar.isHidden = true;

       // navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false;
    }


}

