//
//  HomeController.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/19/21.
//

import UIKit

class HomeController: UIViewController {

    private let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    private let forYouPagingController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )

    private let followingPagingController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )

    private let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = nil
        return control
    }()

    private var forYouPosts: [PostModel] = PostModel.mockModels()
    private var followingPosts: [PostModel] = PostModel.mockModels()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setupFeed()
        horizontalScrollView.delegate = self
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setupHeaderButtons()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }

    private func setupHeaderButtons() {
        navigationItem.titleView = control
        control.addTarget(self, action: #selector(didChangeSegmentedControl(_:)), for: .valueChanged)
    }

    @objc fileprivate func didChangeSegmentedControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex), y: 0), animated: true)
    }

    private func setupFeed() {
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        setupFollowingFeed()
        setupForYouFeed()
    }

    private func setupFollowingFeed() {
        guard let model = followingPosts.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        followingPagingController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil
        )
        horizontalScrollView.addSubview(followingPagingController.view)
        followingPagingController.dataSource = self
        followingPagingController.view.frame = CGRect(x: 0, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(followingPagingController)
        followingPagingController.didMove(toParent: self)
    }

    private func setupForYouFeed() {
        guard let model = forYouPosts.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        forYouPagingController.setViewControllers(
            [vc],
            direction: .forward,
            animated: false,
            completion: nil
        )
        horizontalScrollView.addSubview(forYouPagingController.view)
        forYouPagingController.dataSource = self
        forYouPagingController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(forYouPagingController)
        forYouPagingController.didMove(toParent: self)
    }
}

extension HomeController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {$0.identifier == fromPost.identifier}) else {
            return nil
        }
        if index == 0 {
            return nil
        }
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        guard let index = currentPosts.firstIndex(where: {$0.identifier == fromPost.identifier}) else {
            return nil
        }
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }

    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            return followingPosts
        }
        return forYouPosts
    }
}

extension HomeController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2) {
            control.selectedSegmentIndex = 0
        } else if scrollView.contentOffset.x > (view.width/2) {
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        horizontalScrollView.isScrollEnabled = false
        if horizontalScrollView.contentOffset.x == 0 {
            followingPagingController.dataSource = nil
        } else {
            forYouPagingController.dataSource = nil
        }
        (parent as? UIPageViewController)?.view.isUserInteractionEnabled = false
        let commentVC = CommentViewController(post: post)
        commentVC.delegate = self
        addChild(commentVC)
        commentVC.didMove(toParent: self)
        view.addSubview(commentVC.view)
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.75)
        commentVC.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            commentVC.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }

    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeController: CommentViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentViewController) {
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.75)
        viewController.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { [weak self] done in
            if done {
                DispatchQueue.main.async {
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPagingController.dataSource = self
                    self?.followingPagingController.dataSource = self
                }
            }
        }
    }
}
