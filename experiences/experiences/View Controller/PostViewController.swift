//
//  PostViewController.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet var imageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(back))
		
    }
	@objc func back() {
		dismiss(animated: true, completion: nil)
	}
	@IBAction func addPosterButtonPressed(_ sender: Any) {
		print("addPosterButtonPressed")
	}
	
	@IBAction func recordButtonPressed(_ sender: Any) {
		print("recordButtonPressed")
	}
}
