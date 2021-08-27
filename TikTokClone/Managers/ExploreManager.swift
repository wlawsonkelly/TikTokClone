//
//  ExploreManager.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/26/21.
//

import Foundation
import UIKit

final class ExploreManager {
    static let shared = ExploreManager()

    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.banners.compactMap({
            ExploreBannerViewModel(
                image: UIImage(named: $0.image),
                title: $0.title
            ) {
                //
            }
        })
    }

    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.creators.compactMap({
            ExploreUserViewModel(
                profilePictureImage: UIImage(named: $0.image),
                username: $0.username,
                followerCount: $0.followers_count
            ) {
                //
            }
        })
    }

    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.hashtags.compactMap({
            ExploreHashtagViewModel(
                icon: UIImage(named: $0.image),
                text: $0.tag,
                count: $0.count
            ) {
                //
            }
        })
    }

    public func getExploreTrendingPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.trendingPosts.compactMap({
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                //                
            }
        })
    }

    public func getExploreRecommendedPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }

        return exploreData.recommended.compactMap({
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                //
            }
        })
    }

    public func getExploreNewPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        print(exploreData.trendingPosts)

        return exploreData.recentPosts.compactMap({
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                //
            }
        })
    }

    public func getExplorePopularPosts() -> [ExplorePostViewModel] {
        guard let exploreData = parseExploreData() else { return [] }
        return exploreData.popular.compactMap({
            ExplorePostViewModel(
                thumbNailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                //
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
