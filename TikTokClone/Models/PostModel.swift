//
//  PostModel.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/20/21.
//

import Foundation

struct PostModel {
    let identifier: String
    var isLikeByCurrentUser = false

    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            posts.append(.init(identifier: UUID().uuidString))
        }
        return posts
    }
}
