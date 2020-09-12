//
//  MemoriesCollectionViewController.swift
//  experiences
//
//  Created by Clayton Watkins on 9/11/20.
//  Copyright © 2020 Clayton Watkins. All rights reserved.
//

import UIKit
import MapKit

class MemoriesCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    let locationManager = CLLocationManager.shared
    let postController = PostController.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let post = postController.posts[indexPath.row]
        
        // Sets up cells based on what the post contains
        if post.image != nil {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoEntryCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
            cell.post = post
            cell.delegate = self
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.systemOrange.cgColor
            return cell
        } else if post.audioURL != nil {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AudioEntryCell", for: indexPath) as? AudioCollectionViewCell else { return UICollectionViewCell() }
            cell.post = post
            cell.delegate = self
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.systemOrange.cgColor
            return cell
        } else if post.entry != nil {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TextEntryCell", for: indexPath) as? TextCollectionViewCell else { return UICollectionViewCell() }
            cell.post = post
            cell.delegate = self
            cell.layer.cornerRadius = 8
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.systemOrange.cgColor
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: - IBActions
    // Unwinds us after saving each post
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue){}
    
    // transistions the user to post creation view controller based on their choice
    @IBAction func addPostTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Post", message: "Which kind of post do you want to create?", preferredStyle: .actionSheet)
        
        let imagePostAction = UIAlertAction(title: "Image", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "ImagePostController") as! PhotoEntryViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let audioPostAction = UIAlertAction(title: "Audio", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "AudioPostController") as! AudioEntryViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let textPostAction = UIAlertAction(title: "Text", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "TextPostController") as! TextEntryViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(imagePostAction)
        alert.addAction(audioPostAction)
        alert.addAction(textPostAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

// Allows us to set up and get locations
extension MemoriesCollectionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// Allows us to use the same location manager throughout view controllers
extension CLLocationManager {
    static let shared = CLLocationManager()
}

/* Conforming to our protocols on each UICollectionViewCell so that when we tap our nav button, we are able to get the appropriate indexPath for each cell, and transistionas appropriately to the MapViewController to fill in the blanks and displays location on map with a pin
*/

extension MemoriesCollectionViewController: cellIndexPathDelegate {
    func locationButtonTapped(cell: PhotoCollectionViewCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
        let indexPath = self.collectionView.indexPath(for: cell)
        print(indexPath!.row)
        let post = postController.posts[indexPath!.row]
        vc.location = post.location
        vc.postTitle = post.title
        vc.postAuthor = post.author
    }
}

extension MemoriesCollectionViewController: cellIndexPathDelegate2 {
    func locationButtonTapped(cell: AudioCollectionViewCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
        let indexPath = self.collectionView.indexPath(for: cell)
        let post = postController.posts[indexPath!.row]
        vc.location = post.location
        vc.postTitle = post.title
        vc.postAuthor = post.author
    }
}

extension MemoriesCollectionViewController: cellIndexPathDelegate3 {
    func locationButtonTapped(cell: TextCollectionViewCell) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "MapViewController") as! MapViewController
        self.navigationController?.pushViewController(vc, animated: true)
        let indexPath = self.collectionView.indexPath(for: cell)
        let post = postController.posts[indexPath!.row]
        vc.location = post.location
        vc.postTitle = post.title
        vc.postAuthor = post.author
    }
}
