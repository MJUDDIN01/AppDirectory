//
//  PeopleCollectionViewCell.swift
//  AppDirectory
//
//  Created by Jasim Uddin on 05/05/2022.
//

import UIKit


class PeopleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var posterImageViw: UIImageView!
    
    
    func configureData(people: People) {
        nameLabel.text = people.name
        titleLabel.text = people.jobTitle
        setPosterImageView(imageURL: people.poster)
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 2.0
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.shadowOpacity = 0.2

    }
    
    private func setPosterImageView(imageURL:String) {
        ImageDownloader.shared.getImage(url: imageURL) { [weak self] data in
            DispatchQueue.main.async {
                self?.posterImageViw.image = UIImage(data: data)
            }
        }
    }
}
