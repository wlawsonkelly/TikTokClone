//
//  PostViewController.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/19/21.
//

import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
}

class PostViewController: UIViewController {

    weak var delegate: PostViewControllerDelegate?
    var model: PostModel

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Checkout this label #tiktokclone"
        label.font = .systemFont(ofSize: 26, weight: .medium)
        return label
    }()

    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = [.blue, .green, .orange, .yellow].randomElement()
        setupButtons()
        setupDoubleTapToLike()
        view.addSubview(captionLabel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size: CGFloat = 55
        let yStart: CGFloat = view.height - (size * 3) - (tabBarController?.tabBar.height ?? 0)

        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size, y: yStart + (CGFloat(index) * size), width: size, height: size)
        }

        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(x: 5, y: view.height - view.safeAreaInsets.bottom - labelSize.height - 12 -  (tabBarController?.tabBar.height ?? 0), width: view.width - size - 12, height: labelSize.height)
    }

    fileprivate func setupButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)

        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }

    fileprivate func setupDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }

    @objc fileprivate func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikeByCurrentUser {
            model.isLikeByCurrentUser = true
        }

        let touchPoint = gesture.location(in: view)

        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .red
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)

        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 0
                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }

    @objc fileprivate func didTapLike() {
        model.isLikeByCurrentUser = !model.isLikeByCurrentUser

        likeButton.tintColor = model.isLikeByCurrentUser ? .systemRed : .white
    }

    @objc fileprivate func didTapComment() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }

    @objc fileprivate func didTapShare() {
        guard let url = URL(string: "https://www.facebook.com") else {
            return
        }
        let shareSheet = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(shareSheet, animated: true)
    }
}
