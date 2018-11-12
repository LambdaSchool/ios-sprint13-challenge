//
//  ExperienceNavigationController.swift
//  Experiences
//
//  Created by Farhan on 11/11/18.
//  Copyright © 2018 Farhan. All rights reserved.
//

import UIKit

protocol ExperiencePresenter: class {
    var experienceController: ExperienceController? {get set}
}

class ExperienceNavigationController: UINavigationController {
    
//    let experienceController = ExperienceController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        for vc in children {
//
//            if let vc = vc as? ExperiencePresenter {
//
//                vc.experienceController = experienceController
//
//            }
//
//        }
        
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
