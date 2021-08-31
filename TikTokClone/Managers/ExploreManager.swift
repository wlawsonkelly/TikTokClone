//
//  ExploreManager.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/26/21.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ viewController: UIViewController)

    func didTapHashtag(_ hashtag: String)
}

final class ExploreManager {
    static let shared = ExploreManager()

    weak var delegate: ExploreManagerDelegate?

    enum BannerAction: String {
        case post
        case hashtag
        case user
    }

    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.banners.compactMap({ model in
            ExploreBannerViewModel(
                image: UIImage(named: model.image),
                title: model.title
            ) {
                guard let action = BannerAction(rawValue: model.action) else {
                    return
                }
                switch action {
                case .post:
                    // post
                    break
                case .hashtag:
                    break
                    // hashtag search
                case .user:
                    // profile
                    break
                }
            }
        })
    }

    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.creators.compactMap({ model in
            ExploreUserViewModel(
                profilePictureImage: UIImage(named: model.image),
                username: model.username,
                followerCount: model.followers_count
            ) { [weak self] in
                DispatchQueue.main.async {
                    let userId = model.id
                    // fetch from firebase
                    let vc = ProfileViewController(user: User(identifier: userId, username: "kanye", profilePictureUrl: nil))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }

    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.hashtags.compactMap({ model in
            ExploreHashtagViewModel(
                icon: UIImage(named: model.image),
                text: model.tag,
                count: model.count
            ) {
                DispatchQueue.main.async {
                    self.delegate?.didTapHashtag(model.tag)
                }
            }
        })
    }

    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.trendingPosts.compactMap({ model in
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to get from firebase
                DispatchQueue.main.async {
                    let vc = PostViewController(model: PostModel(identifier: model.id))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }

    public func getExploreRecommendedPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.recommended.compactMap({ model in
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to get from firebase
                DispatchQueue.main.async {
                    let vc = PostViewController(model: PostModel(identifier: model.id))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }

    public func getExploreNewPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        print(exploreData.trendingPosts)

        return exploreData.recentPosts.compactMap({ model in
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to get from firebase
                DispatchQueue.main.async {
                    let vc = PostViewController(model: PostModel(identifier: model.id))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }

    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.popular.compactMap({ model in
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self] in
                // use id to get from firebase
                DispatchQueue.main.async {
                    let vc = PostViewController(model: PostModel(identifier: model.id))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }

    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
        }
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(ExploreResponse.self, from: data)
            return result
        } catch {
            print(error)
            return nil
        }
    }
}

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}

struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post: Codable {
    let id: String
    let image: String
    let caption: String
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}

struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}
