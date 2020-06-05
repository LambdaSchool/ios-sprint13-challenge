//
//  ViewController.swift
//  Experiences
//
//  Created by Shawn James on 6/5/20.
//  Copyright © 2020 Shawn James. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    @IBOutlet weak var plusButton: UIBarButtonItem!
    
    lazy var searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.8 , height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialViews()
    }

    private func setupInitialViews() {
        setupSearchBar()
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Search for a memory..."
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    @IBAction func plusButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    
}

