//
//  ExploreUserCollectionViewCell.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/26/21.
//

import UIKit

class ExploreUserCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExploreUserCollectionViewCell"

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height - 55
        profileImageView.frame = CGRect(
            x: (contentView.width - imageSize)/2,
            y: 0,
            width: imageSize,
            height: imageSize
        )
        usernameLabel.frame = CGRect(
            x: 0,
            y: imageSize,
            width: contentView.width,
            height: 55
        )
        profileImageView.layer.cornerRadius = imageSize / 2
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
    }

    func configure(with viewModel: ExploreUserViewModel) {
        profileImageView.image = viewModel.profilePictureImage
        usernameLabel.text = viewModel.username
    }
}
