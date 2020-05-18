//
//  landingPageViewController.swift
//  Experiences
//
//  Created by denis cedeno on 5/15/20.
//  Copyright © 2020 DenCedeno Co. All rights reserved.
//

import UIKit

class landingPageViewController: UIViewController {
    
    var experirnce: Experience?

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var ImageView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


}
