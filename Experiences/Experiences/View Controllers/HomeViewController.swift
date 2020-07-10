//
//  HomeViewController.swift
//  ExperiencesWorkingDraft
//
//  Created by Cody Morley on 7/10/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import UIKit
//TODO: load experiences from user defaults in vDL with an update views method
//TODO: pass experiences by dependency injection via segues to tableView and MapView VCs

class HomeViewController: UIViewController {
    //MARK: - Properties -
    var experiences: [Experience] = []
    
    
    //MARK: - Life Cycles -
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Methods -
    private func updateViews() {
        
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
