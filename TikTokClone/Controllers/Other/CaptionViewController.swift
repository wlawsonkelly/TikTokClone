//
//  CaptionViewController.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/31/21.
//

import UIKit

class CaptionViewController: UIViewController {

    let videoUrl: URL

    init(videoUrl: URL) {
        self.videoUrl = videoUrl
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    @objc fileprivate func didTapPost() {
        let newVideoName = StorageManager.shared.generateVideoName()

        StorageManager.shared.uploadVideoURL(from: videoUrl, fileName: newVideoName) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    DatabaseManager.shared.insertPost(fileName: newVideoName, caption: "Sick Video") { databaseUpdated in
                        if databaseUpdated {
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        } else {
                            HapticsManager.shared.vibrate(for: .error)
                            let alert = UIAlertController(title: "Woops",
                                                          message: "We were unable to upload your video. Please try again.",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                            self?.present(alert, animated: true)
                        }
                    }
                }
            } else {
                HapticsManager.shared.vibrate(for: .error)
                let alert = UIAlertController(title: "Woops",
                                              message: "We were unable to upload your video. Please try again.",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self?.present(alert, animated: true)
            }
        }
    }
}
