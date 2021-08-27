//
//  ExploreUserViewModel.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/25/21.
//

import Foundation
import UIKit

struct ExploreUserViewModel {
    let profilePictureImage: UIImage?
    let username: String
    let followerCount: Int
    let handler: (() -> Void)
}
