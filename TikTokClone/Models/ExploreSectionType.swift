//
//  ExploreSectionType.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/25/21.
//

import UIKit

enum ExploreSectionType: CaseIterable {
    case banners
    case trendingPosts
    case trendingHashtags
    case users
    case recomended
    case popular
    case new

    var title: String {
        switch self {
        case .banners:
            return "Featured"
        case .trendingPosts:
            return "Trending Videos"
        case .trendingHashtags:
            return "Hashtags"
        case .users:
            return "Popular Creators"
        case .recomended:
            return "Recommended"
        case .popular:
            return "Popular"
        case .new:
            return "Recently Posted"
        }
    }
}
