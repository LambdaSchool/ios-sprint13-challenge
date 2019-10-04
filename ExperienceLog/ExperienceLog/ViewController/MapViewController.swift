//
//  MapViewController.swift
//  ExperienceLog
//
//  Created by Bradley Yin on 10/4/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let postController = PostController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "PostEditorShowSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostEditorShowSegue" {
            guard let postEditorVC = segue.destination as? PostEditorViewController else { fatalError("cant make PostEditorVC") }
            postEditorVC.postController = postController
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var postAnnotations: [PostAnnotation] = []
        for post in self.postController.posts {
            if post.latitude != nil && post.longitude != nil {
                postAnnotations.append(PostAnnotation(post: post))
            }
        }
        DispatchQueue.main.async {
            
            if let firstPostAnnotation = postAnnotations.first {
                let span = MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                let region = MKCoordinateRegion(center: firstPostAnnotation.coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
            }
            self.mapView.addAnnotations(postAnnotations)
        }
    }
    
}
