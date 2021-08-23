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

    let user = User(identifier: UUID().uuidString, username: "ye", profilePictureUrl: nil)

    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            posts.append(.init(identifier: UUID().uuidString))
        }
        return posts
    }
}
