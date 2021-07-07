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
    
    @IBOutlet weak var mapView: MKMapView!
    let postController = PostController()
    var post: Post!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "PostEditorShowSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PostEditorShowSegue" {
            guard let postEditorVC = segue.destination as? PostEditorViewController else { fatalError("cant make PostEditorVC") }
            postEditorVC.postController = postController
        }
        if segue.identifier == "PostDetailShowSegue" {
            guard let postDetailVC = segue.destination as? PostDetailViewController else { fatalError("cant make PostDetailVC") }
            postDetailVC.post = post
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
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let postAnnotaion = view.annotation as? PostAnnotation else { return }
        let post = postAnnotaion.post
        self.post = post
        performSegue(withIdentifier: "PostDetailShowSegue", sender: self)
    }
}
