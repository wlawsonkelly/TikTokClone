//
//  ExploreHashtagViewModel.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/25/21.
//

import Foundation
import UIKit

struct ExploreHashtagViewModel {
    let icon: UIImage?
    let text: String
    let count: Int // number of posts
    let handler: (() -> Void)
}
