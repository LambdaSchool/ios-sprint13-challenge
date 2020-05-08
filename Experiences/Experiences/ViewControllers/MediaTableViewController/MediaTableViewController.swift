//
//  MediaTableViewController.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class MediaTableViewController: UITableViewController {

    // MARK: - Public Properties
    
    var experience: Experience?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Public Methods

    func refresh() {
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let experience = experience else { return 0 }
        switch section {
        case 0:
            return experience.audioClips.count
        case 1:
            return experience.videos.count
        case 2:
            return experience.photos.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return audioCell(forRowAt: indexPath)
        case 1:
            return videoCell(forRowAt: indexPath)
        case 2:
            return photoCell(forRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // Helper functions for cells
    
    private func audioCell(forRowAt indexPath: IndexPath) -> AudioTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as? AudioTableViewCell else {
            fatalError("Unable to cast cell to type \(AudioTableViewCell.self)")
        }
        
        cell.url = experience?.audioClips[indexPath.row]
        
        return cell
    }
    
    private func videoCell(forRowAt indexPath: IndexPath) -> VideoTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as? VideoTableViewCell else {
            fatalError("Unable to cast cell to type \(VideoTableViewCell.self)")
        }
        
        cell.url = experience?.videos[indexPath.row]
        
        return cell
    }
    
    private func photoCell(forRowAt indexPath: IndexPath) -> PhotoTableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotoTableViewCell else {
            fatalError("Unable to cast cell to type \(PhotoTableViewCell.self)")
        }
        
        cell.url = experience?.photos[indexPath.row]
        
        return cell
    }
}
