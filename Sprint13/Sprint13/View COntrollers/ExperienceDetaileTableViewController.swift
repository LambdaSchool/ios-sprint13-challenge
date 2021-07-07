//
//  ExperienceTableViewController.swift
//  Sprint13
//
//  Created by Sergey Osipyan on 2/22/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ExperienceDetaileTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // MARK: - Table view data source

    @IBAction func undoButton(_ sender: Any) {
      //  dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ExperienceController.shared.experiences.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ExperienceTableViewCell
        
        let experience = ExperienceController.shared.experiences[indexPath.row]
        cell.experienceImageView.image = experience.image
        cell.titleLabel.text = experience.title
        cell.experience = experience
        let avPlayer = AVPlayer(url: experience.videoURL as! URL)
        cell.videoPlayerView?.playerLayer.player = avPlayer
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = (cell as? ExperienceTableViewCell) else { return }
        let visibleCells = tableView.visibleCells
        let minIndex = visibleCells.startIndex
        if tableView.visibleCells.index(of: cell) == minIndex {
            videoCell.videoPlayerView.player?.play()
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? ExperienceTableViewCell else { return }
    
        videoCell.videoPlayerView.player?.pause()
        videoCell.videoPlayerView.player = nil
    }
}
