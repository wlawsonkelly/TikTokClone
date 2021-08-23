//
//  CommentTableViewCell.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/22/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        backgroundColor = .white
        addSubview(avatarImageView)
        addSubview(commentLabel)
        addSubview(dateLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()

        let imageSize: CGFloat = 44
        avatarImageView.frame = CGRect(x: 10, y: 5, width: imageSize, height: imageSize)

        commentLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: 5,
            width: contentView.width - avatarImageView.right - 10,
            height: min(contentView.height - dateLabel.top, commentLabel.height)
        )

        dateLabel.frame = CGRect(
            x: avatarImageView.right + 10,
            y: commentLabel.bottom,
            width: dateLabel.width,
            height: dateLabel.height
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        commentLabel.text = nil
        dateLabel.text = nil
    }

    public func configure(with model: PostComment) {
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        if let url = model.user.profilePictureUrl {

        } else {
            avatarImageView.image = UIImage(systemName: "person.circle")?.withRenderingMode(.alwaysOriginal)
        }
    }

}
