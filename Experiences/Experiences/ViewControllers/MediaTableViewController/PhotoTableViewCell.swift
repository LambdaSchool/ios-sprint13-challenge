//
//  PhotoTableViewCell.swift
//  Experiences
//
//  Created by Shawn Gee on 5/8/20.
//  Copyright © 2020 Swift Student. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    var url: URL? { didSet { updateImageView() }}

    @IBOutlet weak var photoImageView: UIImageView!
    
    private func updateImageView() {
        guard let url = url, let imageData = try? Data(contentsOf: url) else { return }
        photoImageView.image = UIImage(data: imageData)
    }
}
