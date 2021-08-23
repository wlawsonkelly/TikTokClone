//
//  CommentViewController.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/22/21.
//

import UIKit

protocol CommentViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentViewController)
}

class CommentViewController: UIViewController {

    weak var delegate: CommentViewControllerDelegate?

    private var comments = [PostComment]()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        tableView.backgroundColor = .white
        return tableView
    }()

    private let post: PostModel

    private let closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()

    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        fetchPostComments()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 60, y: 5, width: 50, height: 50)
        tableView.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.height - closeButton.bottom)
    }

    fileprivate func fetchPostComments() {
        self.comments = PostComment.mockComments()
    }

    @objc fileprivate func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
