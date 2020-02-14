//
//  ExperienceRecordingViewController.swift
//  Experiences
//
//  Created by Chad Rutherford on 2/14/20.
//  Copyright © 2020 Chad Rutherford. All rights reserved.
//

import UIKit

class ExperienceRecordingViewController: UIViewController {
    
    let documentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "memories")
        return imageView
    }()
    
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Title:"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let recordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.setTitle("Record", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .systemRed
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configure()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(presentVideoScreen))
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func presentVideoScreen() {
        let experienceVideoVC = ExperienceVideoViewController()
        navigationController?.pushViewController(experienceVideoVC, animated: true)
    }
    
    private func configure() {
        view.backgroundColor = .systemBackground
        title = "Make a new memory"
        let padding: CGFloat = 20
        view.addSubview(documentImageView)
        view.addSubview(titleTextField)
        view.addSubview(recordButton)
        NSLayoutConstraint.activate([
            documentImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            documentImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            documentImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            documentImageView.heightAnchor.constraint(equalToConstant: 180),
            
            titleTextField.topAnchor.constraint(equalTo: documentImageView.bottomAnchor, constant: padding),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            titleTextField.heightAnchor.constraint(equalToConstant: 40),
            
            recordButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: padding),
            recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recordButton.heightAnchor.constraint(equalToConstant: 40),
            recordButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
