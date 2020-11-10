//
//  ExperienceMemoCollectionViewController.swift
//  MyExperiences
//
//  Created by Gladymir Philippe on 11/8/20.
//

import UIKit
import MapKit

private let reuseIdentifier = "Cell"

class ExperienceMemoCollectionViewController: UICollectionViewController {
    
    let locationManager = CLLocationManager.shared
    let postExperiencesController = PostExperiencesController.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
      //  self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return postExperiencesController.posts.count
        }

        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let post = postExperiencesController.posts[indexPath.row]

            if post.image != nil {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCollectionViewCell else { return UICollectionViewCell() }
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

        // MARK: - Private Methods
        

        // MARK: - IBActions
        @IBAction func unwindSegue(_ sender: UIStoryboardSegue){}
        @IBAction func addPostTapped(_ sender: Any) {
            let alert = UIAlertController(title: "New Post", message: "Which kind of post do you want to create?", preferredStyle: .actionSheet)

            let imagePostAction = UIAlertAction(title: "Image", style: .default) { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "ImagePostController") as! PhotoViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }

            let audioPostAction = UIAlertAction(title: "Audio", style: .default) { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "AudioRecordController") as! AudioRecorderViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }

            let textPostAction = UIAlertAction(title: "Text", style: .default) { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "TextViewController") as! TextViewController
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

    extension ExperienceMemoCollectionViewController: CLLocationManagerDelegate {
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    }

    extension CLLocationManager {
        static let shared = CLLocationManager()
    }

    /* Conforming to our protocols on each UICollectionViewCell so that when we tap our nav button, we are able to get the appropriate indexPath for each cell, and transistionas appropriately to the MapViewController to fill in the blanks and displays location on map with a pin
    */

    extension ExperienceMemoCollectionViewController: cellIndexPathDelegate {
        func locationButtonTapped(cell: PhotoCollectionViewCell) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MapViewController") as! MapViewController
            self.navigationController?.pushViewController(vc, animated: true)
            let indexPath = self.collectionView.indexPath(for: cell)
            print(indexPath!.row)
            let post = postExperiencesController.posts[indexPath!.row]
            vc.location = post.location
            vc.postTitle = post.title!
            vc.postAuthor = post.author
        }
    }

    extension ExperienceMemoCollectionViewController: cellIndexPathDelegate2 {
        func locationButtonTapped(cell: AudioCollectionViewCell) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MapViewController") as! MapViewController
            self.navigationController?.pushViewController(vc, animated: true)
            let indexPath = self.collectionView.indexPath(for: cell)
            let post = postExperiencesController.posts[indexPath!.row]
            vc.location = post.location
            vc.postTitle = post.title!
            vc.postAuthor = post.author
        }
    }

    extension ExperienceMemoCollectionViewController: cellIndexPathDelegate3 {
        func locationButtonTapped(cell: TextCollectionViewCell) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "MapViewController") as! MapViewController
            self.navigationController?.pushViewController(vc, animated: true)
            let indexPath = self.collectionView.indexPath(for: cell)
            let post = postExperiencesController.posts[indexPath!.row]
            vc.location = post.location
            vc.postTitle = post.title!
            vc.postAuthor = post.author
        }
    }
