//
//  PostComment.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/22/21.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date

    static func mockComments() -> [PostComment] {
        let user = User(identifier: UUID().uuidString, username: "ye", profilePictureUrl: nil)

        return [PostComment(text: "This is an awesome post", user: user, date: Date()),
                PostComment(text: "This is an awesome post", user: user, date: Date()),
                PostComment(text: "This is an awesome post", user: user, date: Date()),
                PostComment(text: "This is an awesome post", user: user, date: Date())
        ]

    }
}
