//
//  ExperienceDetailViewController.swift
//  Experiences
//
//  Created by Marlon Raskin on 10/19/19.
//  Copyright © 2019 Marlon Raskin. All rights reserved.
//

import UIKit

class ExperienceDetailViewController: UIViewController {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var audioContainerView: UIView!
    @IBOutlet private weak var videoContainerView: UIView!

    var experience: ExperienceTemp? {
        didSet {
            updateViews()
        }
    }

    private lazy var dateFormatter: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .long
        result.timeStyle = .short
        return result
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    

    @IBAction func audioPlayButtonTapped(_ sender: UIButton) {

    }

    @IBAction func videoPlayButtonTapped(_ sender: UIButton) {

    }

    private func setUI() {
        imageView.layer.cornerRadius = 12
        imageView.layer.cornerCurve = .continuous
        [audioContainerView, videoContainerView].forEach { $0?.layer.cornerRadius = 10 }
        [audioContainerView, videoContainerView].forEach { $0?.layer.cornerCurve = .continuous }
    }

    private func updateViews() {
        loadViewIfNeeded()
        guard let exp = experience else { return }
        title = exp.title
        dateLabel.text = dateFormatter.string(from: exp.timestamp)
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
