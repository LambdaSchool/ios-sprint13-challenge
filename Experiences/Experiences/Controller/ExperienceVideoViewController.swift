//
//  ExperienceVideoViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import UIKit

class ExperienceVideoViewController: UIViewController {
    
    let cameraView: CameraPreviewView = {
        let cameraView = CameraPreviewView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.backgroundColor = .systemBlue
        return cameraView
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "smallcircle.fill.circle"), for: .normal)
        button.tintColor = .systemRed
        button.setPreferredSymbolConfiguration(.init(font: .systemFont(ofSize: 80), scale: .default), forImageIn: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(cameraView)
        cameraView.addSubview(recordButton)
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            recordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
