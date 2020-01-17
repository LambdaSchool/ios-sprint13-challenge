//
//  VideoViewController.swift
//  Unit4-SprintChallenge1
//
//  Created by Lambda_School_Loaner_204 on 1/16/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit

class VideoViewController: UIViewController {

    @IBOutlet weak var postButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.isEnabled = false
        postButton.tintColor = UIColor.gray

    }

    @IBAction func postButtonTapped(_ sender: Any) {

    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
