//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class ExperienceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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

extension ExperienceViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: - Fill out after modelcontroller connected
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: - Fill out after modelcontroller connected
        return UITableViewCell()
    }
    
    
}
