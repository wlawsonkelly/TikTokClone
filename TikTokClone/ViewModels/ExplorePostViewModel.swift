//
//  ExplorePostViewModel.swift
//  TikTokClone
//
//  Created by Lawson Kelly on 8/25/21.
//

import Foundation
import UIKit

struct ExplorePostViewModel {
    let thumbNailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
