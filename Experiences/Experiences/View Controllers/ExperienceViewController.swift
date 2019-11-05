//
//  ExperienceViewController.swift
//  Experiences
//
//  Created by Lambda_School_Loaner_214 on 11/2/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

protocol ExperienceViewControllerDelegate {
    func mediaAdded()
}

class ExperienceViewController: UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uiView: ContainerViewController!
    
    var experience: Experience?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        guard let experience = experience else { return }
        tableView.reloadData()
        titleTF.text = experience.title
        descriptionTF.text = experience.subtitle
    }
    
    @IBAction func addTapped(_ sender: Any) {
        uiView.addMedia()
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
        return experience?.media.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
        if let experience = experience {
            cell.textLabel?.text = experience.media[indexPath.row].mediaType.rawValue
            cell.detailTextLabel?.text = experience.media[indexPath.row].date.formattedString()
        }
        return cell
    }
}

extension ExperienceViewController: ExperienceViewControllerDelegate {
    func mediaAdded() {
        tableView.reloadData()
    }
}
