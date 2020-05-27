//
//  AddImageViewController.swift
//  Experiences
//
//  Created by Gerardo Hernandez on 5/26/20.
//  Copyright © 2020 Gerardo Hernandez. All rights reserved.
//

import UIKit

protocol AddMediaDelegate {
    func didSaveMedia(mediaType: MediaType, to url: URL)
}
class AddImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  var delegate: AddMediaDelegate?
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
