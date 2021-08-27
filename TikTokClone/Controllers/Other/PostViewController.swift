//
//  PostViewController.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/19/21.
//

import UIKit
import AVFoundation

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {

    weak var delegate: PostViewControllerDelegate?
    var model: PostModel

    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "test"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.layer.masksToBounds = true
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

    var player: AVPlayer?

    private var playerDidFinishObserver: NSObjectProtocol?

    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo()
        setupButtons()
        setupDoubleTapToLike()
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
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

        profileButton.frame = CGRect(
            x: likeButton.left,
            y: likeButton.top - size,
            width: size,
            height: size
        )

        profileButton.layer.cornerRadius = size / 2
    }

    fileprivate func setupButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)

        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }

    fileprivate func configureVideo() {
        guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)

        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player?.volume = 0
        player?.play()

        guard let player = player else { return }

        playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
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

    @objc fileprivate func didTapProfileButton() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
    }
}
